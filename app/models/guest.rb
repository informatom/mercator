class Guest < Hobo::Model::Guest

  def administrator?
    false
  end

  def sales?
    false
  end

  def locale
    I18n.default_locale
  end

  attr_accessor :basket
end