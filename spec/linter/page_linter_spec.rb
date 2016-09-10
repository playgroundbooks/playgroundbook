require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe PageLinter do
    include FakeFS::SpecHelpers
    let(:page_linter) { PageLinter.new(page_manifest_linter) }
    let(:page_manifest_linter) { double(PageManifestLinter) }

    it "fails if Contents.swift does not exist" do
      expect { page_linter.lint }.to raise_error(SystemExit)
    end

    it "passes through to page_manifest_linter" do
      File.open(ContentsSwiftFileName, "w") { |f| f.write("") }
      expect(page_manifest_linter).to receive(:lint)
      expect { page_linter.lint }.to_not raise_error
    end
  end
end
