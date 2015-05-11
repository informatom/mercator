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
    is_expected.to respond_to :versions
  end

  it "has an mp3 attached" do
    is_expected.to respond_to(:mp3)
  end

  it "has an ogg attached" do
    is_expected.to respond_to(:ogg)
  end

  #--- Instance Methods --- #

  context "chapter string" do
    it "returns samething" do
      @chapter = create(:chapter)
      create(:chapter, podcast_id: @chapter.podcast.id)
      expect(@chapter.podcast.chapterstring[0][:start]).to eql("00:00:30")
      expect(@chapter.podcast.chapterstring[0][:title]).to eql("Cool Chapter")
    end
  end
end