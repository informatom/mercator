FactoryGirl.define do
  factory :feedback do
    content      "Some feedback"
    conversation
    user         {conversation.customer}
    consultant   {conversation.consultant}
  end
end