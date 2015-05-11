FactoryGirl.define do

  factory :link do
    url "http://www.informatom.com"
    title "Informatom Website"
    conversation

    factory :local_link do
      url "http://shop.domain.com/path/to/some/file"
      title "Local Link"
    end

    factory :suggestion_link do
      url "/conversations/17/suggestions/"
      title "Suggestion"
    end
  end
end