require 'spec_helper'

describe Podcast do
  it "is valid with number, title, shownotes, duration, published_at" do
    expect(build :podcast).to be_valid
  end

  it {should validate_presence_of :number}
  it {should validate_presence_of :title}
  it {should validate_presence_of :shownotes}

  it {should validate_uniqueness_of :number}
  it {should validate_uniqueness_of :title}

  it {should have_many :comments}
  it {should have_many :chapters}

  it "is versioned" do
    should respond_to :versions
  end

  it "has an mp3 attached" do
    should respond_to(:mp3)
  end

  it "has an ogg attached" do
    should respond_to(:ogg)
  end
end