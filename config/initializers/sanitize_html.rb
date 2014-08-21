module HoboFields
  module SanitizeHtml
    def self.sanitize(s)
      s
      # no sanitizing
      # Helper.new.sanitize(s, :tags => PERMITTED_TAGS, :attributes => PERMITTED_ATTRIBUTES)
    end
  end
end