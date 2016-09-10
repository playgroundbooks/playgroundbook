require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe MarkdownWrapper do
    let(:test_ui) { Cork::Board.new(silent: true) }

    it "creates a swift file from a markdown file" do
      source = "spec/fixtures/wrapper/source/swift_at_artsy_1.md"
      destination = "spec/fixtures/wrapper/destination/swift_at_artsy_1.swift"
      subject = MarkdownWrapper.new(source, "Swift at Artsy")
      contents = File.read(source)
      expect(subject.swap_code_context(contents)).to eq(File.read(destination))
    end

    it "creates a playground around the file" do
      source = "spec/fixtures/wrapper/source/swift_at_artsy_1.md"

      Dir.mktmpdir do |dir|
        new_source = File.join(dir, File.basename(source))
        FileUtils.cp(source, new_source)
        subject = MarkdownWrapper.new(new_source, "Swift at Artsy")

        subject.generate

        playground = File.join(dir, "Swift at Artsy.playground")
        expect(Dir.exist?(playground)).to eq(true)
        expect(File.exist?(File.join(playground, "Contents.swift"))).to eq(true)
        expect(File.exist?(File.join(playground, "timeline.xctimeline"))).to eq(true)
        expect(File.exist?(File.join(playground, "contents.xcplayground"))).to eq(true)
      end
    end
  end
end
