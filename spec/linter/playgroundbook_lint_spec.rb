require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe Linter do
    let(:linter) { Linter.new(test_playground_book, contents_linter) }
    let(:contents_linter) { double(ContentsLinter) }

    it "initializes correctly" do
      expect(linter.playground_file_name) == test_playground_book
    end

    it "exits on lint failure" do
      allow(linter).to receive(:contents_dir_exists?)
        .and_return(false)

      expect { linter.lint }.to raise_error(SystemExit)
    end

    it "fails when file does not exist" do
      allow(linter).to receive(:contents_dir_exists?)
        .and_return(false)
      allow(linter).to receive(:fail_lint)
        .with("No Contents directory")
        .and_raise(SystemExit)

      expect { linter.lint }.to raise_error(SystemExit)
    end

    it "lints" do
      allow(linter).to receive(:contents_dir_exists?)
        .and_return(true)
      allow(contents_linter).to receive(:lint)
      expect(Dir).to receive(:chdir).with(test_playground_book)

      linter.lint
    end
  end
end
