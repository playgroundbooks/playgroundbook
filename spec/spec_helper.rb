require 'pathname'

ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

RSpec.configure do |config|
  config.color = true

  config.order = :random
  Kernel.srand config.seed
end
