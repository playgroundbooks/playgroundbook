require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe RootManifestLinter do
    include FakeFS::SpecHelpers
    let(:chapter_linter) { ChapterLinter.new(chapter_manifest_linter) }
    let(:chapter_manifest_linter) { double(ChapterManifestLinter) }
    let(:chapter_directory_name) { "test_chapter" }

    it "fails when chapter directory does not exist" do
      expect { chapter_linter.lint(chapter_directory_name) }.to raise_error(SystemExit)
    end

    it "fails when Pages subdirectory of chapter dir does not exist" do
      FakeFS do
        Dir.mkdir(chapter_directory_name)
        expect { chapter_linter.lint(chapter_directory_name) }.to raise_error(SystemExit)
      end
    end

    it "calls through to chapter manifest linter" do
      FakeFS do
        expect(chapter_manifest_linter).to receive(:lint)
        FileUtils.mkdir_p("#{chapter_directory_name}/Pages")

        expect { chapter_linter.lint(chapter_directory_name) }.to_not raise_error
      end
    end
  end
end
