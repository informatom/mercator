class Constant < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    key   :string, :required, :unique, :name => true
    value :string
    timestamps
  end

  attr_accessible :key, :value
  has_paper_trail

  if Constant.table_exists? # enable initial schema loading
    CMSDOMAIN          = self.find_by_key('cms_domain').try(:value)
    SHOPDOMAIN         = self.find_by_key('shop_domain').try(:value)
    PODCASTDOMAIN      = self.find_by_key('podcast_domain').try(:value)
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
    acting_user.administrator?
  end

  #--- Class Methods --- #

  def self.office_hours?(time: Time.now)
    begin
      office_hours = eval(Constant.find_by(key: :office_hours).value)
    rescue
      return false
    end

    return false unless office_hours && office_hours.class == Hash

    today_sym = time.strftime("%^a").to_sym
    return false unless office_hours[today_sym]

    start_of_work = Time.parse(time.to_date.to_s + " " + office_hours[today_sym][0])
    end_of_work = Time.parse(time.to_date.to_s + " " + office_hours[today_sym][1])

    return time < end_of_work && time > start_of_work
  end


  def self.pretty_office_hours
    begin
      office_hours = eval(Constant.find_by(key: :office_hours).value)
    rescue
      return false
    end

    output = ""
    [:SUN, :MON, :TUE, :WED, :THU, :FRI, :SAT].each_with_index do |day, index|
      if office_hours[day]
        output += I18n.t('date.abbr_day_names')[index] + ": " + office_hours[day][0] + "-" + office_hours[day][1] + " "
      end
    end
    output[-1, 1] = "."
    return output
  end


  def self.page_title_prefix
    self.find_by_key('page_title_prefix').try(:value)
  end


  def self.page_title_postfix
    self.find_by_key('page_title_postfix').try(:value)
  end
end