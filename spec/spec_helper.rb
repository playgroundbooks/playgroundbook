require "pathname"
require "cork"
require "rspec"
require "plist"
require "fileutils"
require "fakefs/spec_helpers"

ROOT = Pathname.new(File.expand_path("../../", __FILE__))
$LOAD_PATH.unshift((ROOT + "lib").to_s)
$LOAD_PATH.unshift((ROOT + "spec").to_s)

require "playgroundbook"
require "linter/abstract_linter"
require "linter/chapter_linter"
require "linter/chapter_manifest_linter"
require "linter/contents_linter"
require "linter/manifest_linter"
require "linter/page_linter"
require "linter/page_manifest_linter"
require "linter/cutscene_page_linter"
require "linter/cutscene_page_manifest_linter"
require "linter/root_manifest_linter"

require "renderer/contents_manifest_generator"
require "renderer/chapter_collator"
require "renderer/page_writer"
require "renderer/page_parser"
require "renderer/glossary_generator"
require "renderer/page_processor"

RSpec.configure do |config|
  config.color = true

  config.order = :random
  Kernel.srand config.seed
end
RSpec::Expectations.configuration.on_potential_false_positives = :nothing

Playgroundbook::AbstractLinter.ui = Cork::Board.new(silent: true)

def test_playground_book
  "spec/fixtures/Starter.playgroundbook"
end

def test_book_metadata
  {
    "name" => "Testing Book",
    "chapters" => ["test_chapter"],
    "identifier" => "com.ashfurrow.testing",
    "resources" => "assets",
    "cover" => "file.jpeg",
    "glossary" => [
      {
        "term" => "definition"
      }
    ]
  }
end

def get_manifest(file_name = Playgroundbook::ManifestFileName)
  Plist.parse_xml(file_name)
end

def test_chapter_contents
  <<-EOSwift
import UIKit

var str = "Hello, playground"

func sharedFunc() {
  print("This should be accessible to all pages.")
}

//// Page 1

str = "Yo, it's page 1."
sharedFunc()

//// Page 2

str = "Page 2 awww yeah."
sharedFunc()
EOSwift
end
