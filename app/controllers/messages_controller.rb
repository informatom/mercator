class MessagesController < ApplicationController

  hobo_model_controller

  auto_actions :create, :show, :index

  def create
    hobo_create do
      this.sender = current_user
      this.save
      PrivatePub.publish_to("/conversations/"+ this.conversation.id.to_s, message: this)
    end
  end
end