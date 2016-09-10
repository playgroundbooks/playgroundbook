require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe CutscenePageLinter do
    include FakeFS::SpecHelpers
    let(:cutscene_page_linter) { CutscenePageLinter.new(cutscene_page_manifest_linter) }
    let(:cutscene_page_manifest_linter) { double(CutscenePageManifestLinter) }

    it "passes through to cutscene_page_manifest_linter" do
      expect(cutscene_page_manifest_linter).to receive(:lint)
      expect { cutscene_page_linter.lint }.to_not raise_error
    end
  end
end
