require 'plist'
require 'playground_book_lint/manifest_linter'

module PlaygroundBookLint
  # A linter for verifying the contents of a page's Manifest.plist
  class PageManifestLinter < ManifestLinter
    def lint
      super()
      # TODO: Check for valid LiveViewMode values.
    end
  end
end
