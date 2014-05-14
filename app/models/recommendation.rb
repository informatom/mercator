class Recommendation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    reason_de :string, :required
    reason_en :string
    timestamps
  end

  attr_accessible :reason_de, :reason_en, :product, :product_id, :recommended_product,
                  :recommended_product_id
  translates :reason
  has_paper_trail

  belongs_to :product
  belongs_to :recommended_product, :class_name => 'Product', :foreign_key => 'recommended_product_id'

  validates :product, :presence => true
  validates :recommended_product_id, :presence => true, :uniqueness => {:scope => :product_id}

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