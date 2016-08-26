require 'pathname'
require 'cork'
require 'rspec'
require 'plist'
require 'fakefs/spec_helpers'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

require 'playgroundbook'
require 'playgroundbook_lint/abstract_linter'
require 'playgroundbook_lint/chapter_linter'
require 'playgroundbook_lint/chapter_manifest_linter'
require 'playgroundbook_lint/contents_linter'
require 'playgroundbook_lint/manifest_linter'
require 'playgroundbook_lint/page_linter'
require 'playgroundbook_lint/page_manifest_linter'
require 'playgroundbook_lint/cutscene_page_linter'
require 'playgroundbook_lint/cutscene_page_manifest_linter'
require 'playgroundbook_lint/root_manifest_linter'

require 'playgroundbook_renderer/contents_manifest_generator'
require 'playgroundbook_renderer/chapter_collator'
require 'playgroundbook_renderer/page_writer'

RSpec.configure do |config|
  config.color = true

  config.order = :random
  Kernel.srand config.seed
end

Playgroundbook::AbstractLinter.ui = Cork::Board.new(silent: true)

def test_playground_book
  'spec/fixtures/Starter.playgroundbook'
end

def test_book_metadata
  {
    'name' => 'Testing Book',
    'chapters' => ['test_chapter'],
    'identifier' => 'com.ashfurrow.testing'
  }
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
