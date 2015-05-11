FactoryGirl.define do

  factory :gtc do
    title_de "Minimale AGBS"
    title_en "Minimal GTCs"
    content_de "Einige Bedingungen"
    content_en "Some terms and conditions"
    version_of "2014-01-22"

    factory :older_gtc do
      version_of "2014-01-21"
    end

    factory :newer_gtc do
      version_of "2014-01-23"
    end
  end
end