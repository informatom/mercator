class Inventory < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name_de    :string, :required
    name_en    :string
    number     :string, :required
    amount     :decimal, :required, :precision => 10, :scale => 2
    unit       :string, :required
    comment_de :string
    comment_en :string
    weight     :decimal, :precision => 10, :scale => 2
    charge     :string
    storage    :string
    timestamps
  end
  attr_accessible :name_de, :name_en, :number, :amount, :unit,
                  :comment_de, :comment_en, :weight, :charge, :storage,
                  :product, :product_id, :photo
  translates :name, :comment
  has_paper_trail

  validates :amount, numericality: true
  validates :weight, numericality: true, allow_nil: true

  has_attached_file :photo,
    :styles => { :large => "1000x1000>", :medium => "500x500>", :small => "250x250>",
                 :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  belongs_to :product
  validates :product, :presence => true

  has_many :prices, dependent: :destroy
  children :prices

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
