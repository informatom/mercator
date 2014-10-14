class ContentElementSerializer < ActiveModel::Serializer

  attributes :name_de, :name_en, :markup, :content_de, :content_en, :created_at, :updated_at, :document_file_name, :photo_file_name
end