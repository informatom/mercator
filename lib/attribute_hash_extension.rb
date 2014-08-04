module AttributeHashExtension

  #--- Instance Methods ---#
  def namely(attributes, prefix: nil)
    hash = {}
    attributes.each do |attribute|
      if prefix
        prefixed_argument = (prefix.to_s + attribute.to_s).to_sym
        hash[prefixed_argument] = self[attribute]
      else
        hash[attribute] = self[attribute]
      end
    end
    return hash
  end
end

ActiveRecord::Base.send :include, AttributeHashExtension