require File.expand_path('../../spec_helper', __FILE__)

module Playgroundbook
  describe Renderer do
    include FakeFS::SpecHelpers
    let(:renderer) { Renderer.new(yaml_file_name, contents_manifest_generator, test_ui) }
    let(:yaml_file_name) { 'book.yml' }
    let(:contents_manifest_generator) { double(ContentsManifestGenerator) }
    let(:test_ui) { Cork::Board.new(silent: true) }

    before do
      File.open(yaml_file_name, 'w') do |file|
        file.write(test_book_metadata.to_yaml)
      end

      allow(contents_manifest_generator).to receive(:generate!)
    end

    it 'initializes correct' do
      expect(renderer.yaml_file_name) == yaml_file_name
    end

    it 'creates a directory with book name' do
      renderer.render!

      expect(Dir.exist?('Testing Book.playgroundbook')).to be_truthy
    end

    context 'within an existing playgroundbook directory' do
      before do
        Dir.mkdir('Testing Book.playgroundbook')
      end

      it 'does not explode when the directory already exists' do
        expect { renderer.render! }.to_not raise_error
      end

      it 'creates a Contents directory within the main bundle dir' do
        renderer.render!

        expect(Dir.exist?('Testing Book.playgroundbook/Contents')).to be_truthy
      end

      context 'withing the Contents directory' do
        before do
          Dir.mkdir('Testing Book.playgroundbook/Contents')
        end

        it 'does not explode when the Contents directory already exists' do
          expect { renderer.render! }.to_not raise_error
        end

        it 'renders main manifest' do
          expect(contents_manifest_generator).to receive(:generate!)

          renderer.render!
        end
      end
    end
  end
end
