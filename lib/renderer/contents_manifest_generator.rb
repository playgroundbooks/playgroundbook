require "plist"

module Playgroundbook
  class ContentsManifestGenerator
    def initialize(ui = Cork::Board.new)
      @ui = ui
    end

    def generate(book_metadata)
      @ui.puts "Generating main manifest file."
      write_manifest_file(book_metadata)
      @ui.puts "Manifest file generated."
    end

    def write_manifest_file(book_metadata)
      File.open(ManifestFileName, "w") do |file|
        file.write(manifest_contents(book_metadata).to_plist)
      end
    end

    def manifest_contents(book_metadata)
      chapters = book_metadata["chapters"].map { |c| "#{c}.playgroundchapter" }
      manifest_contents = {
        "Name" => book_metadata["name"],
        "ContentIdentifier" => book_metadata["identifier"],
        "DeploymentTarget" => book_metadata["deployment_target"] || "ios10.0",
        "Chapters" => chapters,
        "Version" => "1.0",
        "ContentVersion" => "1.0"
      }
      manifest_contents["ImageReference"] = book_metadata["cover"] unless book_metadata["cover"].nil?
      manifest_contents
    end
  end
end
