require 'colored'
require 'cork'

module PlaygroundBookLint
  class AbstractLinter
    @@ui = Cork::Board.new()

   def self.ui=(value)
     @@ui = value
   end

    def fail_lint(msg)
      @@ui.puts msg.red
      exit 1
    end

    def message(msg)
      @@ui.puts msg
    end
  end
end