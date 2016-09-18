require "plist"
require "renderer/page_processor"

module Playgroundbook
  class PageWriter
    def initialize(page_processor = PageProcessor.new, ui = Cork::Board.new)
      @page_processor = page_processor
      @ui = ui
    end

    def write_page(page_name, page_dir_name, imports, page_contents, chapter_info={})
      Dir.mkdir(page_dir_name) unless Dir.exist?(page_dir_name)
      contents_with_import = "//#-hidden-code\n"
      contents_with_import += imports.map { |i| "import #{i}" }.join("\n") + "\n"
      contents_with_import += "//#-end-hidden-code\n"
      contents_with_import += @page_processor.strip_extraneous_newlines(page_contents)

      Dir.chdir(page_dir_name) do
        File.open(ContentsSwiftFileName, "w") do |file|
          file.write(contents_with_import)
        end

        File.open(MANIFEST_FILE_NAME, "w") do |file|
          file.write({
            "Name" => page_name,
            "LiveViewMode" => chapter_info.has_key?("live_view_mode") ? chapter_info["live_view_mode"] : "HiddenByDefault",
            "LiveViewEdgeToEdge" => chapter_info.has_key?("edge_to_edge_live_view") ? chapter_info["edge_to_edge_live_view"] : true,
            "Version" => "1.0",
            "ContentVersion" => "1.0"
          }.to_plist)
        end
      end
    end
  end
end
