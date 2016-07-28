require 'playground_book_lint/manifest_linter'

module PlaygroundBookLint
  # A linter for verifying the contents of a cutscene page's manifest
  class CutscenePageManifestLinter < ManifestLinter
    attr_accessor :page_manifest_linter

    def lint
      # Cutscene references should point to an existant HTML file
      cutscene_reference = manifest_plist_contents['CutsceneReference']
      unless cutscene_reference.nil?
        fail_lint "Cutscene file at '#{cutscene_reference}' must be HTML" unless cutscene_reference =~ /.*\.html$/i
        fail_lint "Cutscene file at '#{cutscene_reference}' doesn't exist" unless File.exist? cutscene_reference
      end
    end
  end
end
