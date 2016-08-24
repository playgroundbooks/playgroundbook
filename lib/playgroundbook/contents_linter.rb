require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/root_manifest_linter'

module PlaygroundBookLint
  # A linter for verifying the contents directory of a playground book
  class ContentsLinter < AbstractLinter
    attr_accessor :root_manfiest_linter

    def initialize(root_manfiest_linter = RootManifestLinter.new)
      @root_manfiest_linter = root_manfiest_linter
    end

    def lint
      Dir.chdir 'Contents' do
        root_manfiest_linter.lint
        # TODO: Other linting?
      end
    end
  end
end
