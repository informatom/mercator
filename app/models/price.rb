class Price < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    value      :decimal, :required, :precision => 10, :scale => 2
    vat        :decimal, :required, :precision => 10, :scale => 2
    valid_from :date
    valid_to   :date
    scale_from :decimal, :precision => 10, :scale => 2
    scale_to   :decimal, :precision => 10, :scale => 2
    timestamps
  end
  attr_accessible :vat, :value, :valid_from, :valid_to, :scale_from,
                  :scale_to, :inventory, :inventory_id
  has_paper_trail

  validates :value, numericality: true, allow_nil: true
  validates :vat, numericality: true, allow_nil: true
  validates :scale_from, numericality: true, allow_nil: true
  validates :scale_to, numericality: true, allow_nil: true

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
