require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe PageManifestLinter do
    include FakeFS::SpecHelpers
    let(:page_manifest_linter) { PageManifestLinter.new }

    it "given a valid manifest does not fail" do
      # TODO: We're not checking optional values yet, more tests to come.
      # See page_manifest_linter.rb and https://github.com/ashfurrow/playground-book-lint/issues/3 for details.

      FakeFS do
        plist = { "Name" => "Test Page" }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }
        expect { page_manifest_linter.lint }.to_not raise_error
      end
    end

    describe "context given a live view mode" do
      it "succeeds with valid values" do
        FakeFS do
          plist = {
            "Name" => "Test Page",
            "LiveViewMode" => "HiddenByDefault"
          }.to_plist
          File.open("Manifest.plist", "w") { |f| f.write(plist) }
          expect { page_manifest_linter.lint }.to_not raise_error
        end
      end

      it "fails with invalid values" do
        FakeFS do
          plist = {
            "Name" => "Test Page",
            "LiveViewMode" => "UnsupportedViewMode"
          }.to_plist
          File.open("Manifest.plist", "w") { |f| f.write(plist) }
          expect { page_manifest_linter.lint }.to raise_error(SystemExit)
        end
      end
    end
  end
end
