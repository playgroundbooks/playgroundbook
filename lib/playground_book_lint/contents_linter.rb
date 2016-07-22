require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/root_manifest_linter'

module PlaygroundBookLint
  class ContentsLinter < AbstractLinter
    def lint
      Dir.chdir 'Contents' do
        RootManifestLinter.new.lint()
        # TODO: Other linting?
      end
    end
  end
end
