class Contracting::ConversationsController < Contracting::ContractingSiteController

  hobo_model_controller

  index_action :grid_index do
    @conversations = Conversation.all

    render json: {
      status: "success",
      total: @conversations.count,
      records: @conversations.collect {
        |conversation| {
          recid:      conversation.id,
          name:       conversation.name,
          customer:   (conversation.customer.name if conversation.customer),
          consultant: (conversation.consultant.name if conversation.consultant),
          created_at: conversation.created_at.utc.to_i*1000,
          updated_at: conversation.updated_at.utc.to_i*1000
        }
      }
    }
  end
end