require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/page_manifest_linter'

module PlaygroundBookLint
  CONTENTS_SWIFT_FILE_NAME = 'Contents.swift'

  class PageLinter < AbstractLinter

    def lint
      fail_lint "Missing #{CONTENTS_SWIFT_FILE_NAME} in #{Dir.pwd}" unless contents_swift_file_exists?

      PageManifestLinter.new().lint()
    end

    def contents_swift_file_exists?
      return File.exist? CONTENTS_SWIFT_FILE_NAME
    end
  end
end