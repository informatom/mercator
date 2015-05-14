require 'spec_helper'

describe PageTemplate do
  it "is valid with name, content" do
    expect(build :page_template).to be_valid
  end

  it {should validate_presence_of :name}
  it {should validate_uniqueness_of :name}

  it {should validate_presence_of :content}

  it {should have_many :webpages}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  # --- Instance Methods --- #

  context "save_to_disk" do
    it "saves_template_to_disk" do
      filename = Rails.root.to_s + "/app/views/page_templates/rspec_test_template.html.erb"
      File.delete(filename) if File.exist?(filename)
      expect(File).not_to exist(filename)
      build(:page_template).save_to_disk
      expect(File).to exist(filename)
      File.delete(filename)
    end
  end
end