FactoryGirl.define do

  factory :comment do
    user
    blogpost
    podcast
    content  "I am a comment"
    ancestry nil
  end
end