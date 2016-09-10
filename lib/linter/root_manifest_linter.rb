require "plist"
require "linter/manifest_linter"
require "linter/chapter_linter"

module Playgroundbook
  # A linter for verifying the contents of a playground book's root manifest
  class RootManifestLinter < ManifestLinter
    attr_accessor :chapter_linter

    def initialize(chapter_linter = ChapterLinter.new)
      @chapter_linter = chapter_linter
    end

    def lint
      super()

      fail_lint "No Chapters directory" unless chapters_directory_exist?
      fail_lint "No Chapters specified" unless chapters_exist?

      # Go into Chapters/ and then each chapter directory, then lint it.
      Dir.chdir "Chapters" do
        manifest_plist_contents["Chapters"].each do |chapter_directory_name|
          chapter_linter.lint(chapter_directory_name)
        end
      end
    end

    def chapters_directory_exist?
      Dir.exist? "Chapters"
    end

    def chapters_exist?
      value_defined_in_manifest?("Chapters")
    end
  end
end
