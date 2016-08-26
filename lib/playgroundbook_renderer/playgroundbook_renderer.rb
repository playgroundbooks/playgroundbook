require 'colored'
require 'pathname'
require 'yaml'
require 'fileutils'
require 'playgroundbook_renderer/contents_manifest_generator'
require 'playgroundbook_renderer/chapter_collator'

module Playgroundbook
  ContentsDirName = 'Contents'
  ChaptersDirName = 'Chapters'

  # A renderer for playground books.
  class Renderer < AbstractLinter
    attr_accessor :yaml_file_name
    attr_accessor :contents_manifest_generator
    attr_accessor :chapter_collator
    attr_accessor :ui

    def initialize(yaml_file_name, 
        contents_manifest_generator = ContentsManifestGenerator.new, 
        chapter_collator = ChapterCollator.new,
        ui = Cork::Board.new)
      @yaml_file_name = yaml_file_name
      @contents_manifest_generator = contents_manifest_generator
      @chapter_collator = chapter_collator
      @ui = ui
    end

    def render!
      ui.puts "Rendering #{yaml_file_name.yellow}..."
      
      book = yaml_contents
      book_dir_name = "#{book['name']}.playgroundbook"
      book_chapter_contents = []
      # TODO: Validate YAML contents?
      begin
        book_chapter_contents = book['chapters'].map do |chapter|
          File.read("#{chapter}.playground/Contents.swift")
        end
      rescue => e
        ui.puts 'Failed to open playground Contents.swift file.'
        raise e
      end

      Dir.mkdir(book_dir_name) unless Dir.exist?(book_dir_name)
      Dir.chdir(book_dir_name) do
        resources_dir = book['resources']
        if !(resources_dir.nil? || resources_dir.empty?)
          Dir.mkdir(ResourcesDirectoryName) unless Dir.exist?(ResourcesDirectoryName)
          FileUtils.cp_r("../#{resources_dir}/*", ResourcesDirectoryName)
        end

        Dir.mkdir(ContentsDirName) unless Dir.exist?(ContentsDirName)
        Dir.chdir(ContentsDirName) do
          @contents_manifest_generator.generate!(book)

          Dir.mkdir(ChaptersDirName) unless Dir.exist?(ChaptersDirName)
          Dir.chdir(ChaptersDirName) do
            # Chapter file name becomes chapter name in playground book.
            book['chapters'].each_with_index do |chapter_file_name, index|
              chapter_file_contents = book_chapter_contents[index]
              @chapter_collator.collate!(chapter_file_name, chapter_file_contents)
            end
          end
        end
      end
    end

    def yaml_contents
      YAML.load(File.open(@yaml_file_name))
    end
  end
end
