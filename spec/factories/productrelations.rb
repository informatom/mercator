FactoryGirl.define do

  factory :productrelation do
    product
    association :related_product, factory: :second_product
  end
end