require 'plist'
require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/chapter_manifest_linter'

module PlaygroundBookLint
  PAGES_DIRECTORY_NAME = 'Pages'
  
  class ChapterLinter < AbstractLinter
    attr_accessor :chapter_directory_name

    def initialize(chapter_directory_name)
      @chapter_directory_name = chapter_directory_name
    end

    def lint
      fail_lint "Chapter specified in manifest does not exist: #{chapter_directory_name}." unless chapter_directory_exists?
      
      Dir.chdir chapter_directory_name do
        fail_lint "Pages directory in chapter does not exist: #{chapter_directory_name}." unless pages_directory_exists?

        ChapterManifestLinter.new().lint()
      end
    end

    def chapter_directory_exists?
      return Dir.exist? chapter_directory_name
    end

    def pages_directory_exists?
      return Dir.exist? PAGES_DIRECTORY_NAME
    end
  end
end