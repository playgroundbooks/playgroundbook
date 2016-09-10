require "linter/abstract_linter"
require "linter/cutscene_page_manifest_linter"

module Playgroundbook
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
