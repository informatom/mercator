class Product < ActiveRecord::Base
  named_scope :since_icecat_import, lambda { |since|
    if since == nil
      { :conditions => { :icecat_last_import => since } }
    else
      { :conditions => [ "icecat_last_import <= ? ", since ] }
    end
  }
end