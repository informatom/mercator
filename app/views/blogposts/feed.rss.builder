xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Informatom"
    xml.description "Blog Informatom EDV-Dienstleistungen e.U."
    xml.link feed_blogposts_url(:rss)

    for blogpost in @blogposts
      xml.item do
        xml.title blogpost.title
        xml.description blogpost.content_element.content
        xml.pubDate blogpost.publishing_date.to_s(:rfc822)
        xml.link blogpost_url(blogpost, :rss)
        xml.guid blogpost_url(blogpost, :rss)
      end
    end
  end
end