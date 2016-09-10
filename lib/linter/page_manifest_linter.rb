require "plist"
require "linter/manifest_linter"

module Playgroundbook
  # A linter for verifying the contents of a page's Manifest.plist
  class PageManifestLinter < ManifestLinter
    SUPPORTED_LIVE_VIEW_MODES = %w(VisibleByDefault HiddenByDefault).freeze

    def lint
      super()

      live_view_mode = manifest_plist_contents["LiveViewMode"]
      unless live_view_mode.nil?
        fail_lint "Unsopported LiveViewMoode '#{live_view_mode}'" unless SUPPORTED_LIVE_VIEW_MODES.include? live_view_mode
      end
    end
  end
end
