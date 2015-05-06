FactoryGirl.define do

  factory :chapter do
    podcast
    start "00:00:30"
    title "Cool Chapter"
    href  "http://mercatorinformatom.com"
  end
end