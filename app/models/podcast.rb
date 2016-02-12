class Podcast < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    number       :integer, :required, :unique
    title        :string, :required, :unique, :name => true
    shownotes    :text, :required
    duration     :string
    published_at :datetime
    timestamps
  end
  attr_accessible :number, :title, :shownotes, :duration, :published_at, :ogg, :mp3
  has_paper_trail

  self.per_page = 3 # Anzahl Seiteneinträge will_paginate
  default_scope { order('podcasts.published_at DESC') }

  has_many :comments
  has_many :chapters

  has_attached_file :mp3
  validates_attachment :mp3, content_type: { content_type: "audio/mp3" }
  has_attached_file :ogg

  validates_attachment :ogg, content_type: { content_type: ['audio/ogg', 'video/ogv', 'application/ogg'] }

  # Allow ".ogg" as an extension for files with the mime type "video/ogg".
  application_ogg = MIME::Types["application/ogg"].first
  application_ogg.add_extensions "ogg"

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

  #--- Instance Methods --- #

  def chapterstring
    self.chapters.map { |chapter| {:start => chapter.start, :title => chapter.title} }
  end
end