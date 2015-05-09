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
    should respond_to :versions
  end

  it "has a document attached" do
    should respond_to :document
  end

  it "has a photo attached" do
    should respond_to :photo
  end
end