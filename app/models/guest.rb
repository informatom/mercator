class Guest < Hobo::Model::Guest

  def administrator?
    false
  end

  def sales?
    false
  end

  def contentmanager?
    false
  end

  def sales
    false
  end

  def locale
    I18n.default_locale
  end

  def name
    I18n.t("mercator.guest")
  end

  def surname
    I18n.t("mercator.guest")
  end

  def id
    nil
  end

  attr_accessor :basket
end