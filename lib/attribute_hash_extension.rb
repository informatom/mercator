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

  def different_attributes(other_object)
    hash = {}
    self.attributes.each do |key, value|
      hash[key] = [value.to_s, other_object.try(key).to_s] unless other_object.try(key) == value
    end
    return hash
  end
end

ActiveRecord::Base.send :include, AttributeHashExtension