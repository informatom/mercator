class AddPodcastsAndChapters < ActiveRecord::Migration
  def self.up
    create_table :podcasts do |t|
      t.integer  :number
      t.string   :title
      t.text     :shownotes
      t.string   :duration
      t.datetime :published_at
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :chapters do |t|
      t.string   :start
      t.string   :title
      t.string   :href
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :podcast_id
    end
    add_index :chapters, [:podcast_id]

    add_column :comments, :podcast_id, :integer

    add_index :comments, [:podcast_id]
  end

  def self.down
    remove_column :comments, :podcast_id

    drop_table :podcasts
    drop_table :chapters

    remove_index :comments, :name => :index_comments_on_podcast_id rescue ActiveRecord::StatementInvalid
  end
end
