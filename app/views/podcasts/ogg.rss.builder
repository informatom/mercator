require 'htmlentities'
coder = HTMLEntities.new

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Layer 8"
    xml.description "Der österreichische IT-Podcast, Informatom EDV-Dienstleistungen e.U."
    xml.link feed_podcasts_url(:rss)

    for podcast in @podcasts
      xml.item do
        xml.episode podcast.number
        xml.title "Episode " + podcast.number.to_s + ":" + podcast.title
        xml.description coder.decode(strip_tags(podcast.shownotes))
        xml.pubDate podcast.published_at.to_s(:rfc822)
        xml.link podcast_url(podcast)
        xml.guid podcast_url(podcast)
        xml.enclosure url: request.protocol + request.host_with_port + podcast.ogg.url, length: podcast.ogg_file_size, type: "audio/mpeg"
      end
    end
  end
end
