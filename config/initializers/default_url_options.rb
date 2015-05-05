  host = Constant.find_by(key: 'cms_domain').try(:value) || "localhost"
  Rails.application.routes.default_url_options[:host] = host
