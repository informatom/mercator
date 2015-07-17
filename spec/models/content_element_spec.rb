require 'spec_helper'

describe ContentElement do
  it "is valid with content_de, content_en, name_de, name_en, markup, document, photo" do
    expect(build :content_element).to be_valid
  end

  it {should validate_presence_of :name_de}
  it {should validate_uniqueness_of :name_de}

  it {should have_many :page_content_element_assignments}
  it {should have_many :webpages}

  it {should belong_to :folder}
  it {should validate_presence_of :folder}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "has a document attached" do
    is_expected.to respond_to :document
  end

  it "has a photo attached" do
    is_expected.to respond_to :photo
  end

# ---  CLass Methods  --- #

  context "find_by_name" do
    it "can be found by name" do
      expect(ContentElement).to respond_to(:find_by_name)
    end
  end

  context "image" do
    it "returns nil if no image found" do
      expect(ContentElement.image(name: "not existing")).to eql(nil)
    end

    it "finds content element by name_de and returns photo" do
      create(:content_element)
      expect(ContentElement.image(name: "Ich bin der deutsche Titel")).to be_an_instance_of Paperclip::Attachment
    end

    it "finds content element by name_en and returns photo" do
      create(:content_element)
      expect(ContentElement.image(name: "I am the english title")).to be_an_instance_of Paperclip::Attachment
    end

  end


# ---  Instance Methods  --- #

  context "thumb_url" do
    it "returns thumb url" do
      @content_element = create(:content_element, photo: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg'))
      expect(@content_element.thumb_url).to include("/system/content_elements/photos/",
                                                    "/small/dummy_image.jpg?")
    end
  end

  context "photo_url" do
    it "returns photo url" do
      @content_element = create(:content_element, photo: fixture_file_upload( Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg'))
      expect(@content_element.photo_url).to include("/system/content_elements/photos/",
                                                    "/original/dummy_image.jpg?")
    end
  end

  context 'parse' do
    context 'html' do
      before :each do
        @content_element = build(:content_element_with_html)
        @parsed_string = Capybara.string(@content_element.parse)
      end

      it "doesn't modify length" do
        expect(@content_element.parse.length).to eql(@content_element.content.length)
      end

      it "html still has the level one heading" do
        expect(@parsed_string).to have_selector("h1")
      end

      it "html still has no level two heading" do
        expect(@parsed_string).not_to have_selector("h2")
      end

      it "html still has no level three heading" do
        expect(@parsed_string).not_to have_selector("h3")
      end
    end

    context 'markdown' do
      before :each do
        @content_element = build(:content_element_with_markdown)
        @parsed_string = Capybara.string(@content_element.parse)
      end

      it "html still has the level one heading" do
        expect(@parsed_string).to have_selector("h1")
      end

      it "html still has no level two heading" do
        expect(@parsed_string).not_to have_selector("h2")
      end

      it "html has a level three heading" do
        expect(@parsed_string).to have_selector("h3")
      end
    end

    context 'textile' do
      before :each do
        @content_element = build(:content_element_with_textile)
        @parsed_string = Capybara.string(@content_element.parse)
      end

      it "html still has the level one heading" do
        expect(@parsed_string).to have_selector("h1")
      end

      it "html has a level two heading" do
        expect(@parsed_string).to have_selector("h2")
      end

      it "html still has no level three heading" do
        expect(@parsed_string).not_to have_selector("h3")
      end
    end

    it "parses photo tag" do
      @parsed_string = Capybara.string(create(:content_element_with_photo_tag).parse)
      expect(@parsed_string).to have_xpath("//img[@alt='photo_name']")
      expect(@parsed_string.find("img")["src"]).to include "original"
    end

    it "parses document tag" do
      @parsed_string = Capybara.string(create(:content_element_with_document_tag).parse)
      expect(@parsed_string).to have_xpath("//a[@name='document_name']")
    end

    it "respects the photo size (e.g. thumb)" do
      @parsed_string = Capybara.string(create(:content_element_with_photo_tag_in_thumb_size).parse)
      expect(@parsed_string).to have_xpath("//img[@alt='photo_name']")
      expect(@parsed_string.find("img")["src"]).to include "thumb"
    end
  end
end