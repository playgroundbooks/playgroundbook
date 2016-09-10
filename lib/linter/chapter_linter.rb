require "plist"
require "linter/abstract_linter"
require "linter/chapter_manifest_linter"

module Playgroundbook
  PAGES_DIRECTORY_NAME = "Pages".freeze

  # A linter for verifying a chapter directory
  class ChapterLinter < AbstractLinter
    attr_accessor :chapter_manifest_linter

    def initialize(chapter_manifest_linter = ChapterManifestLinter.new)
      @chapter_manifest_linter = chapter_manifest_linter
    end

    def lint(chapter_directory_name)
      fail_lint "Chapter specified in manifest does not exist: #{chapter_directory_name}." unless chapter_directory_exists?(chapter_directory_name)

      Dir.chdir chapter_directory_name do
        fail_lint "Pages directory in chapter does not exist: #{chapter_directory_name}." unless pages_directory_exists?

        chapter_manifest_linter.lint
      end
    end

    def chapter_directory_exists?(chapter_directory_name)
      Dir.exist? chapter_directory_name
    end

    def pages_directory_exists?
      Dir.exist? PAGES_DIRECTORY_NAME
    end
  end
end
