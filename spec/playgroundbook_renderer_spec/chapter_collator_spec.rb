require File.expand_path('../../spec_helper', __FILE__)

module Playgroundbook
  describe ChapterCollator do
    include FakeFS::SpecHelpers
    let(:collator) { ChapterCollator.new(test_ui) }
    let(:test_ui) { Cork::Board.new(silent: true) }
    let(:chapter_contents) { test_chapter_contents }
    let(:chapter_name) { 'test_chapter' }

    it 'creates a chapter manifest' do
      collator.collate!(chapter_name, chapter_contents)

      expect(File.exist?(ManifestFileName)).to be_truthy
    end

    context 'the chapter manifest' do
      let(:manifest) { Plist.parse_xml(ManifestFileName) }

      before do
        collator.collate!(chapter_name, chapter_contents)
      end

      it 'has the correct name' do
        expect(manifest['Name']).to eq(chapter_name)
      end

      it 'has the correct pages' do
        expect(manifest['Pages']).to eq([
          'Page 1.playgroundpage', 
          'Page 2.playgroundpage',
        ])
      end
    end
  end
end
