require "linter/abstract_linter"
require "linter/root_manifest_linter"

module Playgroundbook
  # A linter for verifying the contents directory of a playground book
  class ContentsLinter < AbstractLinter
    attr_accessor :root_manfiest_linter

    def initialize(root_manfiest_linter = RootManifestLinter.new)
      @root_manfiest_linter = root_manfiest_linter
    end

    def lint
      Dir.chdir "Contents" do
        root_manfiest_linter.lint
        # TODO: Other linting?
      end
    end
  end
end
