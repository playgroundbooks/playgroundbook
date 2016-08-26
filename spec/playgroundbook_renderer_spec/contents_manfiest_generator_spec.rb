require File.expand_path('../../spec_helper', __FILE__)

module Playgroundbook
  describe ContentsManifestGenerator do
    include FakeFS::SpecHelpers
    let(:generator) { ContentsManifestGenerator.new(book_metadata, test_ui) }
    let(:test_ui) { Cork::Board.new(silent: true) }
    let(:book_metadata) { test_book_metadata }

    it 'creates the manifest file' do
      generator.generate!

      expect(File.exist?('Manifest.plist')).to be_truthy
    end

    describe 'the manifest file' do
      before do
        generator.generate!
      end

      it 'has a book name' do
        expect(get_manifest['Name']).to eq('Testing Book')
      end

      it 'has an identifier' do
        expect(get_manifest['ContentIdentifier']).to eq('com.ashfurrow.testing')
      end

      it 'has a deployment target' do
        expect(get_manifest['DeploymentTarget']).to eq('ios10.0')
      end

      it 'has chapters specified' do
        expect(get_manifest['Chapters']).to eq(['test_chapter.playgroundchapter'])
      end
    end
  end
end