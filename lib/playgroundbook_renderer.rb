require 'colored'
require 'pathname'

module Playgroundbook
  # A renderer for playground books.
  class Renderer < AbstractLinter
    attr_accessor :yaml_file_name
    attr_accessor :contents_linter
    attr_accessor :ui

    def initialize(yaml_file_name, contents_linter = ContentsLinter.new, ui = Cork::Board.new)
      @yaml_file_name = yaml_file_name
      @contents_linter = contents_linter
      @ui = ui
    end

    def render
      ui.puts "Rendering #{yaml_file_name.yellow}..."
    end
  end
end
