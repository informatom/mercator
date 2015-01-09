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
  attr_accessible :number, :title, :shownotes, :duration, :published_at

  self.per_page = 5 # Anzahl Seiteneinträge will_paginate

  has_many :comments
  has_many :chapters

  has_attached_file :mp3
  validates_attachment :mp3, content_type: { content_type: "audio/mp3" }
  has_attached_file :ogg
  validates_attachment :ogg, content_type: { content_type: "video/ogg" }

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