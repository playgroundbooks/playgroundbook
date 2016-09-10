require "fileutils"

module Playgroundbook
  # Converts a Markdown file into a Swift Playground
  # Needs to:
  #  - Switch out code from being in  a block to being a root element
  #  - Comment out non-code comments
  #  - Embed images inside the Resources Dir
  #
  class MarkdownWrapper
    attr_accessor :source, :name, :playground_contents

    def initialize(source, name)
      self.source = source
      self.name = name
      self.playground_contents = File.read(source)
    end

    def generate
      contents = swap_code_context(playground_contents)
      create_a_playground_wrapper(contents)
    end

    def swap_code_context(file_content)
      prefix = "/*:\n"
      suffix = "*/"
      content = file_content.gsub("```swift", "*/\n").gsub("```", "/*:")
      prefix + content + suffix
    end

    def create_a_playground_wrapper(file_content)
      folder = File.dirname(source)
      playground = File.join(folder, name + ".playground")

      FileUtils.rm_r(playground) if Dir.exist?(playground)
      Dir.mkdir(playground)

      xcplayground = <<-XML
<?xml version='1.0' encoding='UTF-8' standalone='yes'?>
<playground version='5.0' target-platform='osx' display-mode='rendered'>
    <timeline fileName='timeline.xctimeline'/>
</playground>
XML

      timeline = <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<Timeline
   version = "3.0">
   <TimelineItems>
   </TimelineItems>
</Timeline>
XML
      File.write(File.join(playground, "contents.xcplayground"), xcplayground)
      File.write(File.join(playground, "timeline.xctimeline"), timeline)
      File.write(File.join(playground, "Contents.swift"), file_content)
    end
  end
end
