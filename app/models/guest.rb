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

  def name
    "Gast"
  end

  def surname
    "Gast"
  end

  attr_accessor :basket
end