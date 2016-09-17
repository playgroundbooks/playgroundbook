require "fileutils"
require "open-uri"

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
      images = get_list_of_images(contents)
      create_a_playground_wrapper(contents, images)
    end

    def swap_code_context(file_content)
      prefix = "import Foundation\n/*:\n"
      suffix = "*/"
      content = file_content.gsub("```swift", "*/\n").gsub("```", "/*:")
      prefix + content + suffix
    end

    def get_list_of_images(file_content)
      file_content.scan(/\!\[.*\]\((.*?)\)/).flatten
    end

    def create_a_playground_wrapper(file_content, images)
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

      resources = File.join(playground, "Resources")
      Dir.mkdir(resources)

      images.each do |image|
        outer_image_path = File.join(folder, image)
        local = File.exist? outer_image_path
        remote = image.include? "http"

        if local
          basedir = File.dirname(image)
          inner_basedir = File.join(resources, basedir)
          Dir.mkdir(inner_basedir) unless Dir.exist?(inner_basedir)
          FileUtils.cp(outer_image_path, inner_basedir)

        elsif remote
          file = File.open(File.join(resources, File.basename(image)), "wb")
          file.write(open(image, "rb").read)
          file_content.gsub!(image, File.basename(image))
        end
      end

      File.write(File.join(playground, "Contents.swift"), file_content)
    end
  end
end
