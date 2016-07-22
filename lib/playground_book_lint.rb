require 'colored'
require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/contents_linter'
require 'pathname'

module PlaygroundBookLint
  class Linter < AbstractLinter
    attr_accessor :playground_file_name

    def initialize(playground_file_name)
      @playground_file_name = playground_file_name
    end

    def lint
      puts "Validating #{playground_file_name.yellow}..."
      
      fail_lint 'No Contents directory' unless contents_dir_exists?

      Dir.chdir @playground_file_name do
        ContentsLinter.new.lint()
      end
    end

    def contents_dir_exists?
      return Dir.exists?(playground_file_name + '/Contents')
    end
  end
end