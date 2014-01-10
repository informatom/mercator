class PageTemplate < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string, :required, :unique
    content :cktext, :required
    legacy_id :integer
    timestamps
  end
  attr_accessible :name, :content, :legacy_id

  has_paper_trail

  has_many :pages

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
    filename = Rails.root.to_s + "/app/views/page_templates/" + self.name + ".html.erb"
    File.open(filename, "w+") do |f|
      f.write(self.content)
    end
  end

end
