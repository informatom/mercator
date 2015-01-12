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

  validates_format_of :answer, :with => %r{8}, :message => I18n.t("mercator.wrong_answer")
  validates_format_of :phone, :with => %r{\A(\+[0-9]{2,3}|0+[0-9]{2,5})[\d\s\/\(\)-]+\z},
                      :allow_blank => :true,
                      :message => "muss die Form +49 1234 12345678 oder 01234 12345678 haben," +
                                  " d.h. +Laendercode Vorwahl lokale_Rufnummer oder " +
                                  " 0Vorwahl lokale_Rufnummer."

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
    acting_user.administrator? || acting_user.sales?
  end
end