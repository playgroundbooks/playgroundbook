require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/cutscene_page_manifest_linter'

module PlaygroundBookLint
  # A linter for verifying cutscene pages
  class CutscenePageLinter < AbstractLinter
    attr_accessor :cutscene_page_manifest_linter

    def initialize(cutscene_page_manifest_linter = CutscenePageManifestLinter.new)
      @cutscene_page_manifest_linter = cutscene_page_manifest_linter
    end

    def lint
      cutscene_page_manifest_linter.lint
    end
  end
end
