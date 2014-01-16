class Guest < Hobo::Model::Guest

  def administrator?
    false
  end

  def sales?
    false
  end

# Attr accessors for the basket
  def basket
     @basket
  end

  def basket=(basket)
    @basket = basket
  end
end