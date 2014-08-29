module HoboFields
  module SanitizeHtml
    def self.sanitize(s)
      # HAS: 20140829 no sanitizing
      s
      # Helper.new.sanitize(s, :tags => PERMITTED_TAGS, :attributes => PERMITTED_ATTRIBUTES)
    end
  end
end