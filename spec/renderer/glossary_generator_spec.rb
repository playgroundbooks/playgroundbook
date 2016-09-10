require File.expand_path("../../spec_helper", __FILE__)

module Playgroundbook
  describe GlossaryGenerator do
    include FakeFS::SpecHelpers
    let(:glossary_generator) { GlossaryGenerator.new }
    let(:glossary) do
      {
      "example term" => "example definition"
    }
    end
    let(:glossary_file_name) { "Contents/Resources/Glossary.plist" }

    before do
      FileUtils.mkdir_p("Contents/Resources")
    end

    it "generates a glossary plist" do
      glossary_generator.generate({}, [], glossary)

      expect(File.exist?(glossary_file_name)).to be_truthy
    end

    context "glossary plist" do
      let(:glossary_plist) { Plist.parse_xml(glossary_file_name) }

      it "has a glossary with correct terms" do
        glossary_generator.generate({}, [], glossary)

        expect(glossary_plist["Terms"]["example term"]["Definition"]).to eq("example definition")
      end

      it "generates correct first use page references" do
        glossary_generator.generate([
                                      {
                                        page_names: ["Page 1"],
                                        page_contents: ["/*: Here's how to use [a thing](glossary://example%20term) */"]
                                      },
                                      {
                                        page_names: ["Should not see this"],
                                        page_contents: ["/*: Here's how to use [a thing](glossary://example%20term) even though this shouldn't match' */"]
                                      }
                                    ],
                                    ["Chapter 1", "Chapter 2"],
                                    glossary)

        expect(glossary_plist["Terms"]["example term"]["FirstUse"]).to eq({
          "PageReference" => "Chapter%201/Page%201",
          "Title" => "Page 1"
        })
      end
    end
  end
end
