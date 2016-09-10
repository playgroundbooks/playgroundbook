require "colored"
require "cork"

module Playgroundbook
  # AbstractLinter provides a base implementation of a linter which a concrete
  # linter subclass can inherit from
  class AbstractLinter
    @ui = Cork::Board.new

    class << self
      attr_accessor :ui
    end

    def fail_lint(msg)
      AbstractLinter.ui.puts msg.red
      exit 1
    end

    def message(msg)
      AbstractLinter.ui.puts msg
    end
  end
end
