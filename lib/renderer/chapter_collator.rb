require "plist"
require "fileutils"
require "renderer/page_writer"

module Playgroundbook
  SharedSourcesDirectoryName = "Sources".freeze
  SharedResourcesDirectoryName = "Resources".freeze
  PreambleFileName = "Preamble.swift".freeze

  class ChapterCollator
    def initialize(page_writer = PageWriter.new, ui = Cork::Board.new)
      @page_writer = page_writer
      @ui = ui
    end

    def collate(chapter_name, parsed_chapter, imports)
      @ui.puts "Processing #{chapter_name.green}."

      chapter_directory_name = "#{chapter_name}.playgroundchapter"
      Dir.mkdir(chapter_directory_name) unless Dir.exist?(chapter_directory_name)
      Dir.chdir(chapter_directory_name) do
        Dir.mkdir(PagesDirectoryName) unless Dir.exist?(PagesDirectoryName)
        Dir.chdir(PagesDirectoryName) do
          parsed_chapter[:page_names].each_with_index do |page_name, index|
            @ui.puts "  Processing #{page_name.green}."

            page_contents = parsed_chapter[:page_contents][index]
            page_dir_name = parsed_chapter[:page_dir_names][index]

            page_source_names = parsed_chapter[:page_source_names][index]
            page_resource_names = parsed_chapter[:page_resource_names][index]

            @page_writer.write_page(page_name, page_dir_name, imports, page_contents, page_source_names, page_resource_names)
          end
        end

        write_chapter_manifest(chapter_name, parsed_chapter[:page_dir_names])
        write_preamble(parsed_chapter[:preamble])
        copy_sources(parsed_chapter[:source_names])
        copy_resources(parsed_chapter[:resource_names])
      end
    end

    def write_chapter_manifest(chapter_name, page_dir_names)
      manifest_contents = {
        "Name" => chapter_name,
        "Pages" => page_dir_names,
        "Version" => "1.0",
        "ContentVersion" => "1.0"
      }
      File.open(ManifestFileName, "w") do |file|
        file.write(manifest_contents.to_plist)
      end
    end

    def write_preamble(preamble)
      Dir.mkdir(SharedSourcesDirectoryName) unless Dir.exist?(SharedSourcesDirectoryName)

      Dir.chdir(SharedSourcesDirectoryName) do
        File.open(PreambleFileName, "w") do |file|
          file.write(preamble)
        end
      end
    end

    def copy_sources(source_names)
      Dir.mkdir(SharedSourcesDirectoryName) unless Dir.exist?(SharedSourcesDirectoryName)

      source_names.each do |source|
        FileUtils.cp("../../../../#{source}", SharedSourcesDirectoryName)
      end
    end

    def copy_resources(resource_names)
      Dir.mkdir(SharedResourcesDirectoryName) unless Dir.exist?(SharedResourcesDirectoryName)

      resource_names.each do |resource|
        FileUtils.cp("../../../../#{resource}", SharedResourcesDirectoryName)
      end
    end
  end
end
