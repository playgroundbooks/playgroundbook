require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe RootManifestLinter do
    include FakeFS::SpecHelpers
    let(:manifest_linter) { ManifestLinter.new }

    it "fails if a Manifest.plist file does not exist" do
      expect { manifest_linter.lint }.to raise_error(SystemExit)
    end

    it "fails if the Manifest.plist file does not contain a Name value" do
      FakeFS do
        plist = {}.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }

        expect { manifest_linter.lint }.to raise_error(SystemExit)
      end
    end

    it "succeeds if the Manifest.plist file is well-formed" do
      FakeFS do
        plist = { "Name" => "My Test Name" }.to_plist
        File.open("Manifest.plist", "w") { |f| f.write(plist) }

        expect { manifest_linter.lint }.to_not raise_error
      end
    end

    it "extracts Manfiest.plist contents from pwd" do
      FakeFS do
        contents = { "key" => "value" }
        File.open("Manifest.plist", "w") { |f| f.write(contents.to_plist) }

        expect(manifest_linter.manifest_plist_contents).to eq(contents)
      end
    end

    describe "key-value checking" do
      before do
      end

      it "checks for non-defined keys in manifest" do
        FakeFS do
          plist = {}.to_plist
          File.open("Manifest.plist", "w") { |f| f.write(plist) }

          expect(manifest_linter.value_defined_in_manifest?("key")).to be_falsy
        end
      end

      it "checks for nil keys in manifest" do
        FakeFS do
          plist = { "key" => nil }.to_plist
          File.open("Manifest.plist", "w") { |f| f.write(plist) }

          expect(manifest_linter.value_defined_in_manifest?("key")).to be_falsy
        end
      end

      it "checks for empty keys in manifest" do
        FakeFS do
          plist = { "key" => "value" }.to_plist
          File.open("Manifest.plist", "w") { |f| f.write(plist) }

          expect(manifest_linter.value_defined_in_manifest?("key")).to be_truthy
        end
      end
    end
  end
end
