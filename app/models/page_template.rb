class PageTemplate < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name      :string, :required, :unique
    content   :text, :required
    legacy_id :integer
    dryml     :boolean
    timestamps
  end
  attr_accessible :name, :content, :legacy_id, :dryml

  has_paper_trail

  has_many :webpages

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
    extension = self.dryml? ? ".dryml" : ".html.erb"
    wrong_extension = self.dryml? ? ".html.erb" : ".dryml"

    filename = Rails.root.to_s + "/app/views/page_templates/" + self.name + extension
    File.open(filename, "w+") do |f|
      f.write(self.content)
    end

    legacy_file = Rails.root.to_s + "/app/views/page_templates/" + self.name + wrong_extension
    File.delete(legacy_file) if File.exists?(legacy_file)
  end
end