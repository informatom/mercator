require 'spec_helper'

describe Blogpost do
  it "is valid with title_de, name_de, post_category, content_element" do
    expect(build :blogpost).to be_valid
  end

  it {should validate_presence_of :title_de}

  it {should belong_to :content_element}
  it {should validate_presence_of :content_element}

  it {should belong_to :post_category}
  it {should validate_presence_of :post_category}

  it {should have_many :comments}

  it "is taggable" do
    is_expected.to respond_to :blogtags
  end

  it "is versioned" do
    is_expected.to respond_to :versions
  end


  # Class Methods

  context "self.latest" do
    before :each do
      create(:blogpost,
             created_at: Time.now - 7.day,
             content_element: create(:content_element_6))
      create(:blogpost,
             created_at: Time.now - 1.day,
             content_element: create(:content_element))
      create(:blogpost,
             created_at: Time.now - 2.day,
             content_element: create(:content_element_2))
      create(:blogpost,
             created_at: Time.now - 3.day,
             content_element: create(:content_element_3))
      create(:blogpost,
             created_at: Time.now - 4.day,
             content_element: create(:content_element_empty))
      create(:blogpost,
             created_at: Time.now - 5.day,
             content_element: create(:content_element_4))
      create(:blogpost,
             created_at: Time.now - 6.day,
             content_element: create(:content_element_5))
    end

    it "returns 5 blogposts" do
      expect(Blogpost.latest.count).eql? 5
    end

    it "returns the latest blogposts" do
      expect(Blogpost.latest.*.created_at.*.to_date).not_to include Date.today - 7.day
    end

    it "returns only blogposts with Content Elements with content" do
      expect(Blogpost.latest.*.content_element.*.content).not_to include nil
    end
  end


  # Instance Methods

  context "name" do
    it "returns name" do
      @blogpost = build(:blogpost)
      expect(@blogpost.name).eql? @blogpost.title
    end
  end
end