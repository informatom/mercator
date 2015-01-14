require 'htmlentities'
coder = HTMLEntities.new

xml.instruct! :xml, :version => "1.0"
  xml.item do
    xml.episode @podcast.number
    xml.title "Episode " + @podcast.number.to_s + ":" + @podcast.title
    xml.description coder.decode(strip_tags(@podcast.shownotes))
    xml.itunes :summary, coder.decode(strip_tags(@podcast.shownotes))
    xml.itunes :author, "Stefan Haslinger"
    xml.itunes :subtitle, "Diese Woche mit " + @podcast.title
    xml.pubDate @podcast.published_at.to_s(:rfc822)
    xml.itunes :duration, @podcast.duration
    xml.link podcast_url(@podcast)
    xml.guid podcast_url(@podcast)
    xml.enclosure url: request.protocol + request.host_with_port + @podcast.mp3.url, length: @podcast.mp3_file_size, type: "audio/mpeg"
  end
end