require "plist"
require "renderer/page_processor"

module Playgroundbook
  class PageWriter
    def initialize(page_processor = PageProcessor.new, ui = Cork::Board.new)
      @page_processor = page_processor
      @ui = ui
    end

    def write_page(page_name, page_dir_name, imports, page_contents, page_sources, page_resources)
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
            "LiveViewMode" => "HiddenByDefault",
            "Version" => "1.0",
            "ContentVersion" => "1.0"
          }.to_plist)
        end

        copy_page_sources(page_sources)
        copy_page_resources(page_resources)
      end
    end

    def copy_page_sources(source_names)
      Dir.mkdir(SharedSourcesDirectoryName) unless Dir.exist?(SharedSourcesDirectoryName)

      source_names.each do |source|
        FileUtils.cp("../../../../../../#{source}", SharedSourcesDirectoryName)
      end
    end

    def copy_page_resources(resource_names)
      Dir.mkdir(SharedResourcesDirectoryName) unless Dir.exist?(SharedResourcesDirectoryName)

      resource_names.each do |resource|
        FileUtils.cp("../../../../../../#{resource}", SharedResourcesDirectoryName)
      end
    end
  end
end
