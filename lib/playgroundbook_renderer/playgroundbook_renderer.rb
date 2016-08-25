require 'colored'
require 'pathname'
require 'yaml'
require 'playgroundbook_renderer/contents_manifest_generator'

module Playgroundbook
  ContentsDirName = 'Contents'

  # A renderer for playground books.
  class Renderer < AbstractLinter
    attr_accessor :yaml_file_name
    attr_accessor :contents_manifest_generator
    attr_accessor :ui

    def initialize(yaml_file_name, 
        contents_manifest_generator = ContentsManifestGenerator.new, 
        ui = Cork::Board.new)
      @yaml_file_name = yaml_file_name
      @contents_manifest_generator = contents_manifest_generator
      @ui = ui
    end

    def render!
      ui.puts "Rendering #{yaml_file_name.yellow}..."
      
      book = yaml_contents
      book_dir_name = "#{book['name']}.playgroundbook"

      Dir.mkdir(book_dir_name) unless Dir.exist?(book_dir_name)

      Dir.chdir(book_dir_name) do
        Dir.mkdir(ContentsDirName) unless Dir.exist?(ContentsDirName)

        Dir.chdir(ContentsDirName) do
          @contents_manifest_generator.generate!
        end
      end
    end

    def yaml_contents
      YAML.load(File.open(@yaml_file_name))
    end
  end
end
