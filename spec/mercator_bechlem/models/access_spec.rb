require 'spec_helper'

describe MercatorBechlem::Access do

# ---  Class Methods  --- #

  describe "download_index" do
    it "downloads and extracts the index" do
      MercatorBechlem::Access.download_index
      expect(File).to exist(Rails.root.join("vendor","bechlem","BRAND.CSV"))
      expect(File).to exist(Rails.root.join("vendor","bechlem","DESCRIPTOR.CSV"))
      expect(File).to exist(Rails.root.join("vendor","bechlem","ITEM.CSV"))
      expect(File).to exist(Rails.root.join("vendor","bechlem","IDENTIFIER.CSV"))
      expect(File).to exist(Rails.root.join("vendor","bechlem","QUALIFIER.CSV"))
      expect(File).to exist(Rails.root.join("vendor","bechlem","ITEM2ITEM.CSV"))
    end
  end

  describe "delete_first_lines" do
    it "deletes the first lines" do
      @count = %x{sed -n '=' #{Rails.root.join("vendor","bechlem","BRAND.CSV")} | wc -l}.to_i
      MercatorBechlem::Access.delete_first_lines
      @count_after = %x{sed -n '=' #{Rails.root.join("vendor","bechlem","BRAND.CSV")} | wc -l}.to_i
      expect(@count_after -  @count).to eql -1
    end
  end
end