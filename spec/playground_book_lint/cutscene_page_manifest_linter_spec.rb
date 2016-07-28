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

    context 'given a cutscene path' do
      it "fails if that file doesn't exist" do
        FakeFS do
          cutscene_reference = 'FakeFile.html'
          plist = {
            'Name' => 'Test Page',
            'CutsceneReference' => cutscene_reference
          }.to_plist
          File.open('Manifest.plist', 'w') { |f| f.write(plist) }

          expect { cutscene_page_manifest_linter.lint }.to raise_error(SystemExit)
        end
      end

      it 'fails with a non-HTML file' do
        FakeFS do
          cutscene_reference = 'RealFile.xml'
          plist = {
            'Name' => 'Test Page',
            'CutsceneReference' => cutscene_reference
          }.to_plist
          File.open('Manifest.plist', 'w') { |f| f.write(plist) }
          File.open(cutscene_reference, 'w')

          expect { cutscene_page_manifest_linter.lint }.to raise_error(SystemExit)
        end
      end

      it 'passes with a valid file' do
        FakeFS do
          cutscene_reference = 'RealFile.html'
          plist = {
            'Name' => 'Test Page',
            'CutsceneReference' => cutscene_reference
          }.to_plist
          File.open('Manifest.plist', 'w') { |f| f.write(plist) }
          File.open(cutscene_reference, 'w')

          expect { cutscene_page_manifest_linter.lint }.not_to raise_error
        end
      end
    end
  end
end
