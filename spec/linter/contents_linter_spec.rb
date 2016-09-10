require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe ContentsLinter do
    include FakeFS::SpecHelpers
    let(:contents_linter) { ContentsLinter.new(root_manifest_linter) }
    let(:root_manifest_linter) { double(RootManifestLinter) }

    it "calls through to root manifest linter" do
      expect(root_manifest_linter).to receive(:lint)

      FakeFS do
        Dir.mkdir "Contents"
        contents_linter.lint
      end
    end
  end
end
