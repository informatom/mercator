# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    content       "Ich bin eine Botschaft"
    conversation
    sender        {conversation.customer}
    reciever      {conversation.consultant}
  end
end
