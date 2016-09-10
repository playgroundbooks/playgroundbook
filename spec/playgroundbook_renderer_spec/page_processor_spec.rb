require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe PageProcessor do
    let(:page_processor) { PageProcessor.new }

    it "removes newlines before markdown blocks" do
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

      expect(page_processor.strip_extraneous_newlines(page_contents)).to eq(processed_page_contents)
    end

    it "removes newlines after markdown blocks" do
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

      expect(page_processor.strip_extraneous_newlines(page_contents)).to eq(processed_page_contents)
    end

    it "removes newlines surrounding single-line markdown blocks" do
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

      expect(page_processor.strip_extraneous_newlines(page_contents)).to eq(processed_page_contents)
    end

    it "does not strip newlines from code" do
      page_contents = <<-EOS
let a = 6

let b = a
      EOS

      expect(page_processor.strip_extraneous_newlines(page_contents)).to eq(page_contents)
    end

    it "it does not strip newlines from the markdown" do
      page_contents = <<-EOS
/*:

 # Header

 Some markdown. The following lines are purposefull left blank.



*/
      EOS

      expect(page_processor.strip_extraneous_newlines(page_contents)).to eq(page_contents)
    end
  end
end
