class AddMp3AndOggToPodcast < ActiveRecord::Migration
  def self.up
    add_column :podcasts, :mp3_file_name, :string
    add_column :podcasts, :mp3_content_type, :string
    add_column :podcasts, :mp3_file_size, :integer
    add_column :podcasts, :mp3_updated_at, :datetime
    add_column :podcasts, :ogg_file_name, :string
    add_column :podcasts, :ogg_content_type, :string
    add_column :podcasts, :ogg_file_size, :integer
    add_column :podcasts, :ogg_updated_at, :datetime
  end

  def self.down
    remove_column :podcasts, :mp3_file_name
    remove_column :podcasts, :mp3_content_type
    remove_column :podcasts, :mp3_file_size
    remove_column :podcasts, :mp3_updated_at
    remove_column :podcasts, :ogg_file_name
    remove_column :podcasts, :ogg_content_type
    remove_column :podcasts, :ogg_file_size
    remove_column :podcasts, :ogg_updated_at
  end
end
