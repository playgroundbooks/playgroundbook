module Playgroundbook
  GlossaryFileName = 'Glossary.plist'.freeze

  class GlossaryGenerator
    def generate!(parsed_chapters, chapter_names, glossary)
      glossary_plist = {
        'Terms' => {}
      }

      glossary.each do |term, definition|
        glossary_plist['Terms'][term] = { 'Definition' => definition }
      end

      File.open(glossary_file_name, 'w') do |file|
        file.write(glossary_plist.to_plist)
      end
    end

    def glossary_file_name
      "#{ContentsDirectoryName}/#{ResourcesDirectoryName}/#{GlossaryFileName}"
    end
  end
end
