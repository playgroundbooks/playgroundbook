require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe PageWriter do
    include FakeFS::SpecHelpers
    let(:page_writer) { PageWriter.new(page_processor, test_ui) }
    let(:page_processor) { double(PageProcessor) }
    let(:test_ui) { Cork::Board.new(silent: true) }
    let(:page_name) { "test page name" }
    let(:page_dir_name) { "test page name.playgroundpage" }
    let(:page_contents) { "// Some swift goes here." }
    let(:generated_page_contesnts) { "//#-hidden-code\nimport UIKit\n//#-end-hidden-code\n// Some swift goes here." }

    before do
      allow(page_processor).to receive(:strip_extraneous_newlines) do |page_contents|
        # Returns the parameter, unprocessed.
        page_contents
      end
    end

    context "with a pre-existing page directory" do
      before do
        Dir.mkdir(page_dir_name)
      end

      it "does not explode" do
        expect { page_writer.write_page(page_name, page_dir_name, ["UIKit"], page_contents) }.to_not raise_error
      end
    end

    it "calls the page processor" do
      expect(page_processor).to receive(:strip_extraneous_newlines)
      page_writer.write_page(page_name, page_dir_name, ["UIKit"], page_contents)
    end

    context "as a consequence of writing rendering" do
      before do
        page_writer.write_page(page_name, page_dir_name, ["UIKit"], page_contents)
      end

      it "creates a directory" do
        expect(Dir.exist?(page_dir_name)).to be_truthy
      end

      it "writes a manifest" do
        expect(Dir.exist?(page_dir_name)).to be_truthy
      end

      it "writes a Contents.swift file" do
        expect(File.exist?("#{page_dir_name}/Contents.swift")).to be_truthy
      end

      it "has correct Contents.swift contents" do
        expect(File.read("#{page_dir_name}/Contents.swift")).to eq(generated_page_contesnts)
      end

      context "the manifest" do
        let(:manifest) { get_manifest("#{page_dir_name}/#{MANIFEST_FILE_NAME}") }

        it "has a name" do
          expect(manifest["Name"]).to eq(page_name)
        end

        it "has a LiveViewMode" do
          expect(manifest["LiveViewMode"]).to eq("HiddenByDefault")
        end
      end
    end
  end
end
