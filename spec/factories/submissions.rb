FactoryGirl.define do

  factory :submission do
    name    "Max Mustermann"
    email   "max.mustermann@private.org"
    phone   "+43 123456789"
    message "I would like to be contacted"
    answer  "8"
  end
end