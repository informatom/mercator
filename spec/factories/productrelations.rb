FactoryGirl.define do

  factory :productrelation do
    product         {product}
    related_product {second_product}
  end
end