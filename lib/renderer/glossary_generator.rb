require "uri"

module Playgroundbook
  GlossaryFileName = "Glossary.plist".freeze

  class GlossaryGenerator
    def generate(parsed_chapters, chapter_names, glossary)
      glossary_plist = {
        "Terms" => {}
      }

      glossary.each do |term, definition|
        glossary_plist["Terms"][term] = { "Definition" => definition }
        escaped_term = URI.escape(term)
        parsed_chapters.each_with_index do |chapter, i|
          pages = chapter[:page_contents]
          page_names = chapter[:page_names]
          chapter_name = URI.escape(chapter_names[i])

          pages.each_with_index do |page, j|
            page_name = URI.escape(page_names[j])
            next if page.scan("](glossary://#{escaped_term})").empty?
            glossary_plist["Terms"][term]["FirstUse"] = {
                "Title" => page_names[j],
                "PageReference" => "#{chapter_name}/#{page_name}"
              }
            break
          end

          # Break if we found the first user.
          break unless glossary_plist["Terms"][term]["FirstUse"].empty?
        end
      end

      File.open(glossary_file_name, "w") do |file|
        file.write(glossary_plist.to_plist)
      end
    end

    def glossary_file_name
      "#{ContentsDirectoryName}/#{ResourcesDirectoryName}/#{GlossaryFileName}"
    end
  end
end
