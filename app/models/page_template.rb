class PageTemplate < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name      :string, :required, :unique
    content   :text, :required
    legacy_id :integer
    dryml     :boolean
    timestamps
  end
  attr_accessible :name, :content, :legacy_id, :dryml, :placeholder_list

  has_paper_trail

  has_many :webpages

  acts_as_taggable_on :placeholder

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

  def save_to_disk
    extension = dryml? ? ".dryml" : ".html.erb"
    wrong_extension = dryml? ? ".html.erb" : ".dryml"

    filename = Rails.root.to_s + "/app/views/page_templates/" + name + extension
    File.open(filename, "w+") do |f|
      f.write(content)
    end

    legacy_file = Rails.root.to_s + "/app/views/page_templates/" + name + wrong_extension
    File.delete(legacy_file) if File.exists?(legacy_file)
  end
end