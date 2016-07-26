require File.expand_path('../../spec_helper', __FILE__)

module PlaygroundBookLint
  describe PageManifestLinter do
    include FakeFS::SpecHelpers
    let(:page_manifest_linter) { PageManifestLinter.new }

    it 'does not fail' do
      # TODO: We're not checking optional values yet, more tests to come.
      # See page_manifest_linter.rb and https://github.com/ashfurrow/playground-book-lint/issues/3 for details.

      FakeFS do
        plist = { 'Name' => 'Test Page' }.to_plist
        File.open('Manifest.plist', 'w') { |f| f.write(plist) }
        expect { page_manifest_linter.lint }.to_not raise_error
      end
    end
  end
end
