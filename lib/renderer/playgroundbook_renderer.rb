require "colored"
require "pathname"
require "yaml"
require "fileutils"
require "nokogiri"
require "renderer/contents_manifest_generator"
require "renderer/chapter_collator"
require "renderer/page_parser"
require "renderer/glossary_generator"

module Playgroundbook
  ContentsDirectoryName = "Contents".freeze
  ChaptersDirName = "Chapters".freeze

  # A renderer for playground books.
  class Renderer < AbstractLinter
    attr_accessor :yaml_file_name
    attr_accessor :contents_manifest_generator
    attr_accessor :page_parser
    attr_accessor :chapter_collator
    attr_accessor :glossary_generator
    attr_accessor :ui

    def initialize(yaml_file_name,
                   contents_manifest_generator = ContentsManifestGenerator.new,
                   page_parser = PageParser.new,
                   chapter_collator = ChapterCollator.new,
                   glossary_generator = GlossaryGenerator.new,
                   ui = Cork::Board.new)
      @yaml_file_name = yaml_file_name
      @contents_manifest_generator = contents_manifest_generator
      @page_parser = page_parser
      @chapter_collator = chapter_collator
      @glossary_generator = glossary_generator
      @ui = ui
    end

    def render
      ui.puts "Rendering #{yaml_file_name.green}..."

      book = yaml_contents
      book_dir_name = "#{book['name']}.playgroundbook"
      parsed_chapters = []
      # TODO: Validate YAML contents?
      begin
        parsed_chapters = book["chapters"].map do |chapter|
          source_names = Dir["#{chapter}.playground/Sources/*.swift"]
          single_page_file = "#{chapter}.playground/Contents.swift"
          if File.exist?(single_page_file)
            c = File.read(single_page_file)
            page_parser.parse_chapter_pages(c, source_names)
          elsif !Dir.glob("#{chapter}.playground/Pages/*.xcplaygroundpage").empty?
            toc = Nokogiri::XML(File.read("#{chapter}.playground/contents.xcplayground"))
            page_names = toc.xpath("//page").map { |p| p["name"] }
            page_contents = page_names.map do |p|
              File.read("#{chapter}.playground/Pages/#{p}.xcplaygroundpage/Contents.swift")
            end
            page_parser.parse_chapter_xcplaygroundpages(page_names, page_contents, source_names)
          else
            raise "Missing valid playground for #{chapter}."
          end
        end
      rescue => e
        ui.puts "Failed to open and parse playground chapter."
        raise e
      end

      Dir.mkdir(book_dir_name) unless Dir.exist?(book_dir_name)
      Dir.chdir(book_dir_name) do
        Dir.mkdir(ContentsDirectoryName) unless Dir.exist?(ContentsDirectoryName)
        Dir.chdir(ContentsDirectoryName) do
          Dir.mkdir(ResourcesDirectoryName) unless Dir.exist?(ResourcesDirectoryName) # Always create a Resources dir, even if empty.
          resources_dir = book["resources"]
          unless resources_dir.nil? || resources_dir.empty?
            @ui.puts "Copying resource directory (#{resources_dir.green}) contents."
            Dir.glob("../../#{resources_dir}/*").each do |file|
              FileUtils.cp(file, ResourcesDirectoryName)
            end
          end
          @contents_manifest_generator.generate(book)

          Dir.mkdir(ChaptersDirName) unless Dir.exist?(ChaptersDirName)
          Dir.chdir(ChaptersDirName) do
            # Chapter file name becomes chapter name in playground book.
            book["chapters"].each_with_index do |chapter_file_name, index|
              parsed_chapter = parsed_chapters[index]
              @chapter_collator.collate(chapter_file_name, parsed_chapter, book["imports"] || ["UIKit"])
            end
          end
        end

        unless book["glossary"].nil?
          @ui.puts "Generating glossary."
          @glossary_generator.generate(parsed_chapters, book["chapters"], book["glossary"])
        end
      end
    end

    def yaml_contents
      YAML.load(File.open(@yaml_file_name))
    end
  end
end
