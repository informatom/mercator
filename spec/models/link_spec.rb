require 'spec_helper'

describe Link do
  it "is valid with title, url, conversation" do
    expect(build(:link)).to be_valid
  end

  it "is versioned" do
    is_expected.to respond_to(:versions)
  end

  it {should belong_to(:conversation)}


  # --- Instance Methods --- #

  context "local?" do
    it "returns true for local link" do
      Constant.send(:remove_const, :SHOPDOMAIN) # just to avoid warning in the next line
      Constant::SHOPDOMAIN = "shop.domain.com"

      expect(build(:local_link).local?).to eq(true)
    end

    it "returns false for external  link" do
      expect(build(:link).local?).to eq(false)
    end
  end

  context "no_suggestion?" do
    it "returns false for suggestion_link" do
      expect(build(:suggestion_link).no_suggestion?).to eq(false)
    end

    it "returns true for external link" do
      expect(build(:link).no_suggestion?).to eq(true)
    end

    it "returns true for other local link" do
      expect(build(:local_link).no_suggestion?).to eq(true)
    end
  end
end
