class Contract < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    term            :integer, :required, :default => 0
    contractnumber  :string
    startdate       :date
    monitoring_rate :decimal, :required, :precision => 13, :scale => 5, :default => 0
    timestamps
  end
  attr_accessible :runtime, :startdate, :user_id, :user_id, :term, :created_at, :updated_at,
                  :customer_id, :customer, :contractnumber, :monitoring_rate
  has_paper_trail

  belongs_to :customer, :class_name => 'User'

  has_many :contractitems, dependent: :destroy, accessible: true

  # --- Permissions --- #

  def create_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.sales? ||
    acting_user.administrator?
  end

  def view_permitted?(field)
#    user_is?(acting_user) ||
    acting_user.sales? ||
    acting_user.administrator?
  end


  # --- Instance Methods --- #

  def enddate
    if term
      startdate + term.months - 1.day
    else
      startdate
    end
  end
end