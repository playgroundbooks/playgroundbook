# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |s|
  s.name        = 'playground-book-lint'
  s.version     = Playgroundbook::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Lints Swift Playground books.'
  s.description	= 'Lints books for Swift Playgrounds on iOS'
  s.authors     = ['Ash Furrow']
  s.homepage	= 'https://github.com/ashfurrow/playground-book-lint'
  s.email       = 'ash@ashfurrow.com'
  s.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.require_paths = ['lib']
  s.executables = ['playgroundbook']
  s.add_runtime_dependency 'plist', '~> 3.2'
  s.add_runtime_dependency 'colored', '~> 1.2'
  s.add_runtime_dependency 'cork', '~> 0.1'
end
