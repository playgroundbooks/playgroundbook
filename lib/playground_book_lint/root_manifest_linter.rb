require 'plist'
require 'playground_book_lint/manifest_linter'
require 'playground_book_lint/chapter_linter'

module PlaygroundBookLint
  class RootManifestLinter < ManifestLinter
    def lint
      super()
      
      fail_lint "No Chapters directory" unless chapters_directory_exist?
      fail_lint "No Chapters specified" unless chapters_exist?
      
      # Go into Chapters/ and then each chapter directory, then lint it.
      Dir.chdir 'Chapters' do
        manifest_plist_contents['Chapters'].each do |chapter_directory_name|
          ChapterLinter.new(chapter_directory_name).lint()
        end
      end
    end

    def chapters_directory_exist?
      return Dir.exist? 'Chapters'
    end

    def chapters_exist?
      value_defined_in_manifest?('Chapters')
    end
  end
end
