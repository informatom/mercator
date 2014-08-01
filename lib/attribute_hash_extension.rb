module AttributeHashExtension

  #--- Instance Methods ---#
  def namely(attributes)
    hash = {}
    attributes.each do |attribute|
      hash[attribute] = self[attribute]
    end
    return hash
  end
end

ActiveRecord::Base.send :include, AttributeHashExtension