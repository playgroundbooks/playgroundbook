require "linter/manifest_linter"
require "linter/page_linter"
require "linter/cutscene_page_linter"

module Playgroundbook
  # A linter for verifying the contents of a chapter's Manifest.plist
  class ChapterManifestLinter < ManifestLinter
    attr_accessor :page_linter, :cutscene_page_linter

    def initialize(page_linter = PageLinter.new, cutscene_page_linter = CutscenePageLinter.new)
      @page_linter = page_linter
      @cutscene_page_linter = cutscene_page_linter
    end

    def lint
      super()

      fail_lint "Chapter has no pages in #{Dir.pwd}" unless chapter_has_manifest_pages?

      manifest_plist_contents["Pages"].each do |page_directory_name|
        # All pages exist inside the /Pages subdirectory, we need to chdir to there first.
        Dir.chdir PAGES_DIRECTORY_NAME do
          fail_lint "Chapter page directory #{page_directory_name} missing in #{Dir.pwd}" unless Dir.exist?(page_directory_name)
          lint_page page_directory_name
        end
      end
    end

    def lint_page(page_directory_name)
      Dir.chdir page_directory_name do
        if page_directory_name =~ /.+\.playgroundpage$/
          page_linter.lint
        elsif page_directory_name =~ /.+\.cutscenepage$/
          cutscene_page_linter.lint
        end
      end
    end

    def chapter_has_manifest_pages?
      value_defined_in_manifest?("Pages")
    end
  end
end
