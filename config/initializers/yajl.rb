ActionController::Renderers.add :json do |json, options|
  json = Yajl.dump(json) unless json.respond_to?(:to_str)
  json = "#{options[:callback]}(#{json})" unless options[:callback].blank?
  self.content_type ||= Mime::JSON
  self.response_body  = json
end