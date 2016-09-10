require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe RootManifestLinter do
    include FakeFS::SpecHelpers
    let(:root_manifest_linter) { RootManifestLinter.new(chapter_linter) }
    let(:chapter_linter) { double(ChapterLinter) }

    it "fails if Chapters directory does not exist" do
      expect { root_manifest_linter.lint }.to raise_error(SystemExit)
    end

    it "fails if manfiest does not include Chapters" do
      FakeFS do
        Dir.mkdir("Chapters")
        plist = { "Name" => "Test" }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }

        expect { root_manifest_linter.lint }.to raise_error(SystemExit)
      end
    end

    it "calls through to lint each chapter" do
      FakeFS do
        plist = { "Chapters" => ["test_chapter_name"], "Name" => "Test" }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }
        Dir.mkdir("Chapters")

        expect(chapter_linter).to receive(:lint).with("test_chapter_name")

        expect { root_manifest_linter.lint }.to_not raise_error
      end
    end
  end
end
