require 'spec_helper'

describe MercatorBechlem::Base do


  # ---  Class Methods  --- #

  it "is not coupled to a table" do
    expect(MercatorBechlem::Base.abstract_class).to eql true
  end

  it "allows to import data from csv" do
    expect(MercatorBechlem::Base.connection_config["local_infile"]).to eql true
  end

  it "allows to import empty nil values" do
    expect(MercatorBechlem::Base.connection_config["strict"]).to eql false
  end

  describe "update_from_download" do
    it "updates from download" do
      expect(MercatorBechlem::Base).to receive(:connection).exactly(12).times.and_return(MercatorBechlem::Base.connection)
      MercatorBechlem::Base.update_from_download
    end
  end

  describe "copy_views_to_tables" do
    it "copies views to tables" do
      expect(MercatorBechlem::Base).to receive(:connection).exactly(4).times.and_return(MercatorBechlem::Base.connection)
      MercatorBechlem::Base.copy_views_to_tables
    end
  end
end