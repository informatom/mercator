FactoryGirl.define do

  factory :message do
    content       "Ich bin eine Botschaft"
    conversation
    sender        {conversation.customer}
    reciever      {conversation.consultant}
  end
end