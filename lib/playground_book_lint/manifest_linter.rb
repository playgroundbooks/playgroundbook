require 'plist'
require 'playground_book_lint/abstract_linter'

module PlaygroundBookLint
  MANIFEST_FILE_NAME = 'Manifest.plist'

  class ManifestLinter < AbstractLinter

    #TODO: Should load manifest file in initialize instead of lazily.

    def lint
      fail_lint "No Manifest file in #{Dir.pwd}" unless manifest_file_exists?
      fail_lint "Manifest file missing Name in #{Dir.pwd}" unless has_name?
    end

    def manifest_file_exists?
      return File.exists? MANIFEST_FILE_NAME
    end

    def manifest_plist_contents
      return @manifest_plist_contents unless @manifest_plist_contents.nil?
      require 'plist'
      @manifest_plist_contents = Plist::parse_xml(MANIFEST_FILE_NAME)
      return @manifest_plist_contents
    end

    def has_name?
      value_defined_in_manifest?('Name')
    end

    def value_defined_in_manifest?(key)
      return false if manifest_plist_contents.nil?
      return false if manifest_plist_contents[key].nil?
      return false if manifest_plist_contents[key].empty?
      return true
    end
  end
end
