require 'pathname'
require 'cork'
require 'rspec'
require 'plist'
require 'fakefs/spec_helpers'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

require 'playgroundbook_lint'
require 'playgroundbook/abstract_linter'
require 'playgroundbook/chapter_linter'
require 'playgroundbook/chapter_manifest_linter'
require 'playgroundbook/contents_linter'
require 'playgroundbook/manifest_linter'
require 'playgroundbook/page_linter'
require 'playgroundbook/page_manifest_linter'
require 'playgroundbook/cutscene_page_linter'
require 'playgroundbook/cutscene_page_manifest_linter'
require 'playgroundbook/root_manifest_linter'

RSpec.configure do |config|
  config.color = true

  config.order = :random
  Kernel.srand config.seed
end

def test_playground_book
  'spec/fixtures/Starter.playgroundbook'
end

Playgroundbook::AbstractLinter.ui = Cork::Board.new(silent: true)
