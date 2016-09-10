require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe ChapterCollator do
    include FakeFS::SpecHelpers
    let(:collator) { ChapterCollator.new(page_writer, test_ui) }
    let(:page_writer) { double(PageWriter) }
    let(:test_ui) { Cork::Board.new(silent: true) }
    let(:parsed_chapter) { PageParser.new.parse_chapter_pages(test_chapter_contents) }
    let(:chapter_name) { "test_chapter" }

    before do
      allow(page_writer).to receive(:write_page)
    end

    it "creates a chapter manifest" do
      collator.collate(chapter_name, parsed_chapter, [])

      expect(File.exist?("#{chapter_name}.playgroundchapter/#{ManifestFileName}")).to be_truthy
    end

    context "the chapter manifest" do
      before do
        collator.collate(chapter_name, parsed_chapter, ["UIKit"])
      end

      it "has the correct name" do
        expect(get_manifest("#{chapter_name}.playgroundchapter/#{ManifestFileName}")["Name"]).to eq(chapter_name)
      end

      it "has the correct pages" do
        expect(get_manifest("#{chapter_name}.playgroundchapter/#{ManifestFileName}")["Pages"]).to eq([
                                                                                                       "Page 1.playgroundpage",
                                                                                                       "Page 2.playgroundpage"
                                                                                                     ])
      end
    end

    it "calls the page_writer for each page" do
      expect(page_writer).to receive(:write_page).with("Page 1", "Page 1.playgroundpage", [], "str = \"Yo, it's page 1.\"\nsharedFunc()")
      expect(page_writer).to receive(:write_page).with("Page 2", "Page 2.playgroundpage", [], "str = \"Page 2 awww yeah.\"\nsharedFunc()")

      collator.collate(chapter_name, parsed_chapter, [])
    end

    it "does not explode if a Source directory already exists" do
      expect { collator.collate(chapter_name, parsed_chapter, []) }.to_not raise_error
    end

    context "having colated" do
      before do
        collator.collate(chapter_name, parsed_chapter, [])
      end

      it "creates a Source directory if one does not exist" do
        expect(Dir.exist?("#{chapter_name}.playgroundchapter/#{SharedSourcesDirectoryName}")).to be_truthy
      end

      context "Sources folder" do
        it "has a Preamble.swift file" do
          expect(File.exist?("#{chapter_name}.playgroundchapter/#{SharedSourcesDirectoryName}/#{PreambleFileName}")).to be_truthy
        end

        it "has the correct preamble contents" do
          expect(File.read("#{chapter_name}.playgroundchapter/#{SharedSourcesDirectoryName}/#{PreambleFileName}")).to eq("import UIKit\n\nvar str = \"Hello, playground\"\n\nfunc sharedFunc() {\n  print(\"This should be accessible to all pages.\")\n}")
        end
      end
    end
  end
end
