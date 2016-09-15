module Playgroundbook
  class PageParser
    def parse_chapter_pages(chapter_contents, source_names)
      # Looks for //// PageName separators.
      page_names = chapter_contents.scan(/\/\/\/\/.*$/).map { |p| p.gsub("////", "").strip }
      page_dir_names = page_names.map { |p| "#{p}.playgroundpage" }

      split_file = chapter_contents.split(/\/\/\/\/.*$/)
      page_contents = split_file.drop(1).map(&:strip)
      preamble = split_file.first.strip

      {
        page_dir_names: page_dir_names,
        page_names: page_names,
        page_contents: page_contents,
        preamble: preamble,
        source_names: source_names
      }
    end

    def parse_chapter_xcplaygroundpages(page_names, page_contents, source_names)
      page_dir_names = page_names.map { |p| "#{p}.playgroundpage" }

      {
        page_dir_names: page_dir_names,
        page_names: page_names,
        page_contents: page_contents,
        source_names: source_names
      }
    end
  end
end
