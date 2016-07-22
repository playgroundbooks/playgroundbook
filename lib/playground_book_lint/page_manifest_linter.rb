require 'plist'
require 'playground_book_lint/manifest_linter'

module PlaygroundBookLint
  class PageManifestLinter < ManifestLinter
    def lint
      super()
        # TODO: Check for valid LiveViewMode values.
    end
  end
end