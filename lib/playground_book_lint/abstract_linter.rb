require 'colored'
require 'cork'

module PlaygroundBookLint
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
