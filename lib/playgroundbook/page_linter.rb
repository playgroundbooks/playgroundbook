require 'playgroundbook/abstract_linter'
require 'playgroundbook/page_manifest_linter'

module Playgroundbook
  CONTENTS_SWIFT_FILE_NAME = 'Contents.swift'.freeze

  # A linter for verifying the contents of a page directory
  class PageLinter < AbstractLinter
    attr_accessor :page_manifest_linter

    def initialize(page_manifest_linter = PageManifestLinter.new)
      @page_manifest_linter = page_manifest_linter
    end

    def lint
      fail_lint "Missing #{CONTENTS_SWIFT_FILE_NAME} in #{Dir.pwd}" unless contents_swift_file_exists?

      page_manifest_linter.lint
    end

    def contents_swift_file_exists?
      File.exist? CONTENTS_SWIFT_FILE_NAME
    end
  end
end
