class Categorization < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    position :integer, :required
    timestamps
  end

  # can be found in mercator/vendor/engines/mercator_mesonic/app/models/order_extensions.rb
  if Constant.table_exists? && Rails.application.config.try(:erp) == "mesonic"
    include CategorizationExtensions
  end

  attr_accessible :product, :product_id, :category, :category_id
  has_paper_trail
  default_scope { order('categorizations.position ASC') }

  belongs_to :category
  belongs_to :product
  acts_as_list :scope => :category

  validates :product, :presence => true
  validates :category_id, :presence => true, :uniqueness => {:scope => :product_id}

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator? || acting_user.productmanager?
  end

  def update_permitted?
    acting_user.administrator? || acting_user.productmanager?
  end

  def destroy_permitted?
    acting_user.administrator? || acting_user.productmanager?
  end

  def view_permitted?(field)
    true
  end


  # ---  CLass Methods  --- #

  def self.complement(product: nil, category: nil)
    Categorization.find_or_create_by(product_id: product.id, category_id: category.id) do |category|
      unless category.position
        category.position = try_to(1) { category.categorizations.maximum(:position).next }
      end
    end
  end
end
