require 'htmlentities'
coder = HTMLEntities.new

xml.instruct! :xml, :version => "1.0"

xml.item do
  xml.title @blogpost.title
  xml.description @blogpost.content_element.content
  xml.pubDate @blogpost.publishing_date.to_s(:rfc822)
  xml.link blogpost_url(@blogpost, :rss)
  xml.guid blogpost_url(@blogpost, :rss)
end