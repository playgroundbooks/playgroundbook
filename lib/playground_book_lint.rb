module PlaygroundBookLint
  class Linter
    attr_accessor :playground_file_name

    def initialize(playground_file_name)
      @playground_file_name = playground_file_name
    end

    def lint
      puts "Hi! #{playground_file_name}"
    end

  end
end