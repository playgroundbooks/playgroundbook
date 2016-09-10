require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe ChapterManifestLinter do
    include FakeFS::SpecHelpers
    let(:chapter_manifest_linter) { ChapterManifestLinter.new(page_linter) }
    let(:page_linter) { double(PageLinter) }
    let(:page_directory_name) { "test.playgroundpage" }

    it "fails if no Pages defined in Manifest" do
      FakeFS do
        plist = { "Name" => "Test" }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }

        expect { chapter_manifest_linter.lint }.to raise_error(SystemExit)
      end
    end

    it "fails if Pages dir specified in Manifest does not exist" do
      FakeFS do
        plist = { "Name" => "Test", "Pages" => [page_directory_name] }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }
        Dir.mkdir("Pages")

        expect { chapter_manifest_linter.lint }.to raise_error(SystemExit)
      end
    end

    it "calls through to page linter" do
      FakeFS do
        expect(page_linter).to receive(:lint)
        plist = { "Name" => "Test", "Pages" => [page_directory_name] }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }
        FileUtils.mkdir_p("Pages/#{page_directory_name}")

        expect { chapter_manifest_linter.lint }.to_not raise_error
      end
    end
  end
end
