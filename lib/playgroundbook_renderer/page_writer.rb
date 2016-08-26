require 'plist'

module Playgroundbook
  class PageWriter

    def initialize(ui = Cork::Board.new)
      @ui = ui
    end

    def write_page!(page_name, page_dir_name, page_contents)
      Dir.mkdir(page_dir_name) unless Dir.exist?(page_dir_name)

      File.open("#{page_dir_name}/#{CONTENTS_SWIFT_FILE_NAME}", 'w') do |file|
        file.write(page_contents)
      end

      File.open("#{page_dir_name}/#{MANIFEST_FILE_NAME}", 'w') do |file|
        file.write ({
          'Name' => page_name,
          'LiveViewMode' => 'HiddenByDefault',
        }.to_plist)
      end
    end
  end
end