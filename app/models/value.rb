class Value < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title_de :string
    title_en :string
    value    :decimal, :precision => 10, :scale => 2
    flag     :boolean
    unit_de  :string
    unit_en  :string
    timestamps
  end
  attr_accessible :title_de, :title_en, :value, :flag, :product, :property_group, :property
  translates :title
  has_paper_trail

  belongs_to :property_group
  validates :property_group, :presence => true

  belongs_to :property
  validates :property, :presence => true

  belongs_to :product
  validates :product, :presence => true

  lifecycle do
    state :textual, default: true
    state :numeric, :flag
  end

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
