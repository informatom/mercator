class Guest < Hobo::Model::Guest

  def administrator?
    false
  end

  def sales?
    false
  end
end