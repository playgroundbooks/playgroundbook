require 'plist'

module Playgroundbook
  class ContentsManifestGenerator
    def initialize(book_metadata, ui = Cork::Board.new)
      @book_metadata = book_metadata
      @ui = ui
    end

    def generate!
      @ui.puts "Generating main manifest file."
      write_manifest_file!
      @ui.puts "Manifest file generated."
    end

    def write_manifest_file!
      File.open(ManifestFileName, 'w') do |file|
        file.write(manifest_contents.to_plist)
      end
    end

    def manifest_contents
      chapters = @book_metadata['chapters'].map{ |c| "#{c}.playgroundchapter" }
      {
        'Name' => @book_metadata['name'],
        'ContentIdentifier' => @book_metadata['identifier'],
        'DeploymentTarget' => @book_metadata['deployment_target'] || 'ios10.0',
        'Chapters' => chapters
      }
    end
  end
end