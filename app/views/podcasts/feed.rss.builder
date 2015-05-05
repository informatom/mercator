require 'htmlentities'
coder = HTMLEntities.new

xml.instruct! :xml, :version => "1.0"

xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
        "xmlns:atom" => "http://www.w3.org/2005/Atom",
        :version => "2.0" do
  xml.channel do
    xml.atom :link, href: rss_feed_url(:rss, locale: nil), rel: "self", type: "application/rss+xml"

    xml.title "Layer 8"
    xml.description "Layer 8 ist der österreichischer IT-Podcast powered by Informatom. Ihr Host Stefan Haslinger stellt in unregelmäßiger Folge interessante Persönlichkeiten der österreichischen IT-Szene vor und plaudert mit ihnen über Business, Technolgie, Menschen und Trivia."
    xml.itunes :summary, "Layer 8 ist der österreichischer IT-Podcast powered by Informatom. Ihr Host Stefan Haslinger stellt in unregelmäßiger Folge interessante Persönlichkeiten der österreichischen IT-Szene vor und plaudert mit ihnen über Business, Technolgie, Menschen und Trivia."
    xml.link rss_feed_url(:rss, locale: nil)
    xml.itunes :image, href: request.protocol + request.host_with_port + asset_path("logo.png")
    xml.language "de-de"
    xml.itunes :subtitle, "Der österreichische IT-Podcast"
    xml.itunes :category, text: "Technology"
    xml.itunes :category, text: "Business"
    xml.itunes :explicit, "clean"
    xml.itunes :author, "Stefan Haslinger"
    xml.itunes :owner do
      xml.itunes :name, "Stefan Haslinger"
      xml.itunes :email, "stefan.haslinger@informatom.com"
    end

    for podcast in @podcasts
      xml.item do
        # xml.episode podcast.number
        xml.title "Episode " + podcast.number.to_s + ":" + podcast.title
        xml.description coder.decode(strip_tags(podcast.shownotes))
        xml.itunes :summary, coder.decode(strip_tags(podcast.shownotes))
        xml.itunes :author, "Stefan Haslinger"
        xml.itunes :subtitle, "Diese Woche mit " + podcast.title
        xml.pubDate podcast.published_at.to_s(:rfc822)
        xml.itunes :duration, podcast.duration
        xml.link podcast_url(podcast)
        xml.guid podcast_url(podcast)
        xml.enclosure url: request.protocol + request.host_with_port + podcast.mp3.url, length: podcast.mp3_file_size, type: "audio/mpeg"
      end
    end
  end
end