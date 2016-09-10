require "linter/abstract_linter"
require "linter/page_manifest_linter"

module Playgroundbook
  # A linter for verifying the contents of a page directory
  class PageLinter < AbstractLinter
    attr_accessor :page_manifest_linter

    def initialize(page_manifest_linter = PageManifestLinter.new)
      @page_manifest_linter = page_manifest_linter
    end

    def lint
      fail_lint "Missing #{ContentsSwiftFileName} in #{Dir.pwd}" unless contents_swift_file_exists?

      page_manifest_linter.lint
    end

    def contents_swift_file_exists?
      File.exist? ContentsSwiftFileName
    end
  end
end
