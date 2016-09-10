require "linter/manifest_linter"

module Playgroundbook
  # A linter for verifying the contents of a cutscene page's manifest
  class CutscenePageManifestLinter < ManifestLinter
    attr_accessor :page_manifest_linter

    def lint
      super()

      # Cutscene references should point to an existent HTML file
      cutscene_reference = manifest_plist_contents["CutsceneReference"]
      fail_lint "Cutscene manifest doesn't reference a cutscene file" if cutscene_reference.nil?
      fail_lint "Cutscene file at '#{cutscene_reference}' isn't HTML" unless cutscene_reference =~ /^.+\.html$/i
      fail_lint "Cutscene file at '#{cutscene_reference}' doesn't exist" unless File.exist? cutscene_reference
    end
  end
end
