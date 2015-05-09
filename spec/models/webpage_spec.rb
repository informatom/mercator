require 'spec_helper'

describe Webpage do
  it "is valid with title_de, title_en, url, position, page_template" do
    expect(build :webpage).to be_valid
  end

  it {should validate_presence_of :title_de}
  it {should validate_presence_of :position}

  it {should validate_numericality_of :position}

  it {should respond_to :name}

  it {should belong_to :page_template}
  it {should validate_presence_of :page_template}

  it {should have_many :page_content_element_assignments}
  it {should have_many :content_elements}

  it "is versioned" do
    should respond_to :versions
  end

  it "is in a tree structure" do
    should respond_to :parent
    should respond_to :children
  end
end