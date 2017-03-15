module Playgroundbook
  class PageParser
    def parse_chapter_pages(chapter_contents, source_names, resource_names)
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
        page_source_names: [[]] * page_names.count,   # TODO: Be less hacky
        page_resource_names: [[]] * page_names.count, # TODO: Be less hacky
        source_names: source_names,
        resource_names: resource_names
      }
    end

    def parse_chapter_xcplaygroundpages(pages_data, source_names, resource_names)
      page_dir_names = pages_data.map { |p| "#{p[:name]}.playgroundpage" }
      page_names = pages_data.map { |p| "#{p[:name]}" }
      page_contents = pages_data.map { |p| "#{p[:contents]}" }
      page_source_names = pages_data.map { |p| p[:sources] }
      page_resource_names = pages_data.map { |p| p[:resources] }

      {
        page_dir_names: page_dir_names,
        page_names: page_names,
        page_contents: page_contents,
        page_source_names: page_source_names,
        page_resource_names: page_resource_names,
        source_names: source_names,
        resource_names: resource_names
      }
    end
  end
end
