require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe MarkdownWrapper do

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

    it "gets the image files inside the markdown doc" do
      source = "spec/fixtures/wrapper/source/swift_at_artsy_1.md"
      subject = MarkdownWrapper.new(source, "Swift at Artsy")
      expect(subject.get_list_of_images(subject.playground_contents)).to eq(
        ["img/welcome.png", "img/newplayground.png", "img/emptyplayground.png", "img/results.png"]
      )
    end

    it "embeds the local images inside the resources folder" do
      source = "spec/fixtures/wrapper/source/swift_at_artsy_1.md"

      Dir.mktmpdir do |dir|
        new_source = File.join(dir, File.basename(source))
        FileUtils.cp(source, new_source)

        # images need to be in the tmpdir relative for picking up
        Dir.mkdir(File.join(dir, "img"))
        FileUtils.cp(source, File.join(dir, "img", "welcome.png"))

        subject = MarkdownWrapper.new(new_source, "Swift at Artsy")
        subject.generate

        embedded_img = File.join(dir, "Swift at Artsy.playground", "Resources", "img/welcome.png")
        expect(File.exist?(embedded_img)).to eq(true)
      end
    end

    it "embeds remote images inside the resources folder, and changes the MD content to match relative url" do
      source = "spec/fixtures/wrapper/source/swift_at_artsy_1.md"

      Dir.mktmpdir do |dir|
        new_source = File.join(dir, File.basename(source))
        FileUtils.cp(source, new_source)

        subject = MarkdownWrapper.new(new_source, "Swift at Artsy")
        # Switch out a relative link to a remote one
        remote_image = "http://ortastuff.s3.amazonaws.com/site/images/twitter_black.png"
        subject.playground_contents.gsub!("img/welcome.png", remote_image)

        subject.generate

        source_path = File.join(dir, "Swift at Artsy.playground", "Contents.swift")
        expect(File.read(source_path)).to include("twitter_black.png")
        expect(File.read(source_path)).to_not include(remote_image)

        embedded_img = File.join(dir, "Swift at Artsy.playground", "Resources", "twitter_black.png")
        expect(File.exist?(embedded_img)).to eq(true)
      end
    end
  end
end
