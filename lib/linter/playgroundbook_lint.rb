require "colored"
require "linter/abstract_linter"
require "linter/contents_linter"
require "pathname"

module Playgroundbook
  # A linter for verifying a playground book
  class Linter < AbstractLinter
    attr_accessor :playground_file_name
    attr_accessor :contents_linter

    def initialize(playground_file_name, contents_linter = ContentsLinter.new)
      @playground_file_name = playground_file_name
      @contents_linter = contents_linter
    end

    def lint
      message "Validating #{playground_file_name.yellow}..."

      fail_lint "No Contents directory" unless contents_dir_exists?

      Dir.chdir playground_file_name do
        contents_linter.lint
      end
    end

    def contents_dir_exists?
      Dir.exist?(playground_file_name + "/Contents")
    end
  end
end
