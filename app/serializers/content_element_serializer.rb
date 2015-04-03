class ContentElementSerializer < ActiveModel::Serializer
  attributes :name_de, :name_en, :markup, :content_de, :content_en,
             :created_at, :updated_at, :document_file_name, :photo_file_name, :recid,
             :thumb_url, :photo_url

  def attributes
    data = super
    data[:content_de] = ActionController::Base.helpers.strip_tags(content_de.to_s)
    data[:content_en] = ActionController::Base.helpers.strip_tags(content_en.to_s)
    data
  end
end