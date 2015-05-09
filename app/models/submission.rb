class Submission < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name    :string, :required
    email   :email_address, :required
    phone   :string
    message :text
    answer  :string, :required
    timestamps
  end
  attr_accessible :name, :email, :phone, :message, :answer

  has_paper_trail

  validates_format_of :answer, :with => %r{8}

  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator? ||
    acting_user.sales? ||
    new_record?
  end
end