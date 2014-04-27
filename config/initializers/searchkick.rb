module Searchkick
  class Results

   def response
     @response
   end

   def hits
      @response["hits"]["hits"]
    end
  end
end