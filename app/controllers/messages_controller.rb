class MessagesController < ApplicationController

  hobo_model_controller
  auto_actions :create, :show, :index

  def create
    hobo_create do
      this.sender = current_user
      this.save
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/conversations/"+ this.conversation.id.to_s,
                            type: "messages")
      PrivatePub.publish_to("/" + CONFIG[:system_id] + "/personal/"+ this.reciever_id.to_s,
                            sender: this.sender.name,
                            content: this.content)
    end
  end
end