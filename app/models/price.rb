class Price < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    value      :decimal, :required
    vat        :decimal, :required
    valid_from :date
    valid_to   :date
    scale_from :decimal
    scale_to   :decimal
    timestamps
  end
  attr_accessible :vat, :value, :valid_from, :valid_to, :scale_from,
                  :scale_to, :inventory, :inventory_id
  has_paper_trail

  belongs_to :inventory
  validates :inventory, :presence => true

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

end
