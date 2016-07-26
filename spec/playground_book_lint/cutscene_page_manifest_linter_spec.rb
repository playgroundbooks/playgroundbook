require File.expand_path('../../spec_helper', __FILE__)

module PlaygroundBookLint
  describe CutscenePageManifestLinter do
    include FakeFS::SpecHelpers
    let(:cutscene_page_manifest_linter) { CutscenePageManifestLinter.new }

    it 'does not fail' do
      FakeFS do
        plist = { 'Name' => 'Test Page' }.to_plist
        File.open('Manifest.plist', 'w') { |f| f.write(plist) }
        expect { cutscene_page_manifest_linter.lint }.to_not raise_error
      end
    end
  end
end
