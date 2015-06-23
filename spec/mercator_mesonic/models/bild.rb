# This tests are only runnable, if there is a CWLSYSTEM database existing, where images can be imported from.

# require 'spec_helper'

# describe MercatorMesonic::Bild do

#   # ---  Class Methods  --- #

#   context "setup" do
#     it "knows its table name" do
#       expect(MercatorMesonic::Bild.table_name).to eql "t022cmp"
#     end

#     it "knows its primary key" do
#       expect(MercatorMesonic::Bild.primary_key).to eql "c000"
#     end
#   end

#   # ---  Class Methods  --- #

#   describe "import" do
#     it "imports the product images" do
#       # This method is highly customer specific, so testing exceeding existance makes no sense
#       expect(MercatorMesonic::Bild.import).to eql true
#     end
#   end



#   # ---  Instance Methods  --- #

#   it "is readonly" do
#     expect(MercatorMesonic::Bild.new().readonly?).to eql true
#   end
# end