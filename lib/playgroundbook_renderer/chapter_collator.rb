require 'plist'

module Playgroundbook

  class ChapterCollator
    def initialize(page_writer = PageWriter.new, ui = Cork::Board.new)
      @page_writer = page_writer
      @ui = ui
    end

    def collate!(chapter_name, chapter_file_contents)
      # So we need to divide the chapter_file_contents into pages, write those
      # pages & their manifests to their respective directories, and generate a
      # chapter manifest. Easy. 
      # Oh, and write the shared preamble.
      # And assets. Let's make that book-wide for simplicity.

      pages = parse_pages(chapter_file_contents)
      
      pages[:page_names].each_with_index do |page_name, index|
        page_contents = pages[:page_contents][index]
        page_dir_name = pages[:page_dir_names][index]

        @page_writer.write_page!(page_name, page_dir_name, page_contents)
      end

      write_chapter_manifest!(chapter_name, pages[:page_dir_names])
    end

    def parse_pages(swift)
      page_names = swift.scan(/\/\/\/\/.*$/).map { |p| p.gsub('////', '').strip }
      page_dir_names = page_names.map { |p| "#{p}.playgroundpage" }

      split_file = swift.split(/\/\/\/\/.*$/)
      page_contents = split_file.drop(1).map { |p| p.strip }
      preamble = split_file.first

      {
        page_dir_names: page_dir_names,
        page_names: page_names,
        page_contents: page_contents,
        preamble: preamble,
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