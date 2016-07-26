require 'playground_book_lint/manifest_linter'
require 'playground_book_lint/page_linter'

module PlaygroundBookLint
  # A linter for verifying the contents of a chapter's Manifest.plist
  class ChapterManifestLinter < ManifestLinter
    attr_accessor :page_linter

    def initialize(page_linter = PageLinter.new)
      @page_linter = page_linter
    end

    def lint
      super()

      fail_lint "Chapter has no pages in #{Dir.pwd}" unless chapter_has_manifest_pages?

      manifest_plist_contents['Pages'].each do |page_directory_name|
        # All pages exist inside the /Pages subdirectory, we need to chdir to there first.
        Dir.chdir PAGES_DIRECTORY_NAME do
          fail_lint "Chapter page directory #{page_directory_name} missing in #{Dir.pwd}" unless Dir.exist?(page_directory_name)

          Dir.chdir page_directory_name do
            page_linter.lint
          end
        end
      end
    end

    def chapter_has_manifest_pages?
      value_defined_in_manifest?('Pages')
    end
  end
end
