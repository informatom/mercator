class Lineitem < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position       :integer, :required
    product_number :string, :required
    description_de :string, :required
    description_en :string
    amount         :decimal, :required, :precision => 10, :scale => 2
    unit           :string, :required
    product_price  :decimal, :required, :scale => 2, :precision => 10
    vat            :decimal, :required, :precision => 10, :scale => 2
    value          :decimal, :required, :scale => 2, :precision => 10
    timestamps
  end

  attr_accessible :position, :product_number, :description_de, :description_en,
                  :amount, :product_price, :product_price, :vat, :value, :value, :order_id, :order
  translates :description
  has_paper_trail
  default_scope order('position ASC')

  validates :position, numericality: true
  validates :amount, numericality: true
  validates :product_price, numericality: true
  validates :vat, numericality: true
  validates :value, numericality: true
  validates :product_number, :uniqueness => {:scope => :order_id}
  validates :position, :uniqueness => {:scope => :order_id}

  belongs_to :user, :creator => true
  validates :user, :presence => true

  belongs_to :order
  validates :order, :presence => true
  # --- Permissions --- #

  def create_permitted?
    true
  end

  def update_permitted?
    order.user == acting_user || acting_user.administrator?
  end

  def destroy_permitted?
    order.user == acting_user || acting_user.administrator?
  end

  def view_permitted?(field)
    self.new_record? || order.user == acting_user || acting_user.administrator?
  end
end