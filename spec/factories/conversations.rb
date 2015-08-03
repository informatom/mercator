FactoryGirl.define do

  factory :conversation do
    name        "Freudliche Beratung"
    association :customer, factory: :user
    association :consultant, factory: :sales

    factory :second_conversation do
      name "Noch eine Konversation"
    end
  end
end