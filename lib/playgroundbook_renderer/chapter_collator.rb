require 'plist'

module Playgroundbook

  class ChapterCollator
    def initialize(ui = Cork::Board.new)
      @ui = ui
    end

    def collate!(chapter_name, chapter_file_contents)
      # So we need to divide the chapter_file_contents into pages, write those
      # pages & their manifests to their respective directories, and generate a
      # chapter manifest. Easy. 

      pages = parse_pages(chapter_file_contents)
            
      write_chapter_manifest!(chapter_name, pages[:page_dir_names])
    end

    def parse_pages(swift)
      page_names = swift.scan(/\/\/\/\/.*$/).map { |p| p.gsub('////', '').strip }
      page_dir_names = page_names.map { |p| "#{p}.playgroundpage" }
      {
        page_names: page_names,
        page_dir_names: page_dir_names
      }
    end

    def write_chapter_manifest!(chapter_name, page_dir_names)
      manifest_contents = {
        'Name' => chapter_name,
        'Pages' => page_dir_names,
      }
      File.open(ManifestFileName, 'w') do |file|
        file.write(manifest_contents.to_plist)
      end
    end
  end
end