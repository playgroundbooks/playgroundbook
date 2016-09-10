module Playgroundbook
  class PageProcessor
    def strip_extraneous_newlines(page_contents)
      # Three cases we need to look for:
      # - Extraneous newlines before /*:
      # - Extraneous newlines after */
      # - Extraneous newlines either before or after //:
      page_contents
        .gsub(/\n+\/\*:/, "\n/*:")
        .gsub(/\*\/\n+/, "*/\n")
        .split(/(\/\/:.*$)\n*/).join("\n") # Important to do this before the next line, because it adds newlines before //: comments.
        .gsub(/\n+\/\/:/, "\n//:")
    end
  end
end
