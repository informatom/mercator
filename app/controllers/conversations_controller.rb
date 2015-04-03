class ConversationsController < ApplicationController

  hobo_model_controller
  auto_actions :show, :index, :lifecycle
  show_action :suggestions

  def refresh
    self.this = Conversation.find(params[:id])
    hobo_show
  end

  def show
    hobo_show do
      if current_user.class == Guest || current_user.id == this.customer_id
        reciever_id = this.consultant_id
      else
        reciever_id = this.customer_id
      end

      sender_id = current_user.id if logged_in?

      @message = Message.new(reciever_id: reciever_id,
                             conversation_id: this.id,
                             sender_id: sender_id)
    end
  end

  def initiate
    self.this = Conversation.new(customer: current_user, name: I18n.t("mercator.salutation.callback"))
    current_basket.update(conversation_id: this.id)
    creator_page_action :initiate

    holiday_country_code = Constant.find_by_key('holiday_country_code').try(:value).try(:to_sym) || :at

    message_content =
      if Holidays.on(Date.today, holiday_country_code).any?
        I18n.t('mercator.salutation.holidays')
      elsif Constant.office_hours?
        I18n.t('mercator.salutation.call', first_name: User.robot.first_name, surname: User.robot.surname)
      else
        I18n.t('mercator.salutation.out_of_office_hours') + Constant.pretty_office_hours
      end

    self.this.messages << Message.new(conversation_id: this.id,
                                      reciever: this.customer,
                                      sender: User.robot,
                                      content: message_content)
  end

  def do_initiate
    do_creator_action :initiate do
      self.this.update(customer: current_user)
      self.this.delay.inform_sales(locale: I18n.locale) # we fork into delayed handling
    end
  end

  def do_feedback
    do_transition_action :feedback do
      @feedback = Feedback.new(content: params[:conversation][:content])
      case params[:conversation][:mode]
      when "all"
        @feedback.update(user_id:         this.customer_id,
                         consultant_id:   this.consultant_id,
                         conversation_id: this.id)
      when "user"
        @feedback.update(user_id: this.customer_id)
      when "consultant"
        @feedback.update(consultant_id: this.consultant_id)
      else
        @feedback.save
      end
    end
  end

  def suggestions
    @conversation = Conversation.find(params[:id])
    self.this = @products = @conversation.products.paginate(:page => 1, :per_page => @conversation.products.count)
    hobo_index
  end
end