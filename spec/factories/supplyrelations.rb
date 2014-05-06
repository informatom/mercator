FactoryGirl.define do

  factory :supplyrelation do
    product
    association :supply, factory: :second_product
  end
end