# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    url "http://www.informatom.com"
    title "Informatom Website"
    conversation
  end
end
