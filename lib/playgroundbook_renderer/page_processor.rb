module Playgroundbook
  class PageProcessor
    def process_page(page_contents)
      # Three cases we need to look for:
      # - Extraneous newlines before /*:
      # - Extraneous newlines after */
      # - Extraneous newlines either before or after //:
      page_contents.squeeze("\n")
    end
  end
end
