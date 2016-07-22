require 'colored'

module PlaygroundBookLint
  class AbstractLinter
    def fail_lint(msg)
      puts msg.red
      exit 1
    end
  end
end