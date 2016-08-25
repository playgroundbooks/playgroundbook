require File.expand_path('../spec_helper', __FILE__)

module Playgroundbook
  describe Linter do
    include FakeFS::SpecHelpers
    let(:renderer) { Renderer.new(yaml_file_name, test_ui) }
    let(:yaml_file_name) { 'book.yml' }
    let(:test_ui) { Cork::Board.new(silent: true) }

    before do
      File.open(yaml_file_name, 'w') do |file|
        file.write({
          'name' => 'Testing Book',
          'chapters' => ['test_chapter']
        }.to_yaml)
      end
    end

    it 'initializes correct' do
      expect(renderer.yaml_file_name) == yaml_file_name
    end

    it 'creates a directory with book name' do
      renderer.render

      expect(Dir.exist?('Testing Book.playgroundbook')).to be_truthy
    end

    it 'does not explode when the directory already exists' do
      Dir.mkdir('Testing Book.playgroundbook')

      expect { renderer.render }.to_not raise_error
    end
  end
end
