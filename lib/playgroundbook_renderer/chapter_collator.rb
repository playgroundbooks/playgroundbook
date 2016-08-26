require 'plist'

module Playgroundbook

  class ChapterCollator
    def initialize(ui = Cork::Board.new)
      @ui = ui
    end

    def collate!(chapter_file_contents, chapter_file_name)
    end
  end
end