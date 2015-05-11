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

end