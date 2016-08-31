require File.expand_path('../../spec_helper', __FILE__)

module Playgroundbook
  describe PageProcessor do
    let(:page_processor) { PageProcessor.new }
    
    it 'removes newlines before markdown blocks' do
      page_contents = <<-EOS
let a = 6

/*:
 Some markdown.
*/
      EOS
      processed_page_contents = <<-EOS
let a = 6
/*:
 Some markdown.
*/
      EOS
      
      expect(page_processor.process_page(page_contents)).to eq(processed_page_contents)
    end

    it 'removes newlines after markdown blocks' do
      page_contents = <<-EOS
/*:
 Some markdown.
*/

let a = 6
      EOS
      processed_page_contents = <<-EOS
/*:
 Some markdown.
*/
let a = 6
      EOS
      
      expect(page_processor.process_page(page_contents)).to eq(processed_page_contents)
    end

    it 'removes newlines surrounding single-line markdown blocks' do
      page_contents = <<-EOS
let a = 6

//: Some markdown.

let b = a
      EOS
      processed_page_contents = <<-EOS
let a = 6
//: Some markdown.
let b = a
      EOS
      
      expect(page_processor.process_page(page_contents)).to eq(processed_page_contents)
    end
  end
end
