host = Constant.find_by(key: 'cms_domain').try(:value) if defined? Constant

host ||= "localhost"
Rails.application.routes.default_url_options[:host] = host