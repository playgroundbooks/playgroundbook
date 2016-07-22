require 'pathname'
require 'cork'
require 'rspec'
require 'plist'
require 'fakefs/spec_helpers'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

require 'playground_book_lint'
require 'playground_book_lint/abstract_linter'
require 'playground_book_lint/root_manifest_linter'
require 'playground_book_lint/chapter_linter'

RSpec.configure do |config|
  config.color = true

  config.order = :random
  Kernel.srand config.seed
end

def test_playground_book
  'spec/fixtures/Starter.playgroundbook'
end

PlaygroundBookLint::AbstractLinter.ui = Cork::Board.new(silent: true)
