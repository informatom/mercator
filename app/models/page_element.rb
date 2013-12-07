class PageElement < ActiveRecord::Base

  hobo_model # Don't put anything above this
  UsageType = HoboFields::Types::EnumString.for("ContentElement")

  fields do
    used_as    :string
    usage_type PageElement::UsageType
    timestamps
  end
  attr_accessible :used_as, :page, :usage_type, :usage_id

  validates :used_as, :presence => true, :uniqueness => {:scope => :page_id}

  has_paper_trail

  belongs_to :page
  validates :page, :presence => true

  belongs_to :usage, :polymorphic => true
  validates :usage, :presence => true

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
