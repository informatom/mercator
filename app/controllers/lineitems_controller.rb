class LineitemsController < ApplicationController

  hobo_model_controller
  auto_actions :destroy, :lifecycle

  def do_delete_from_basket
    do_transition_action :delete_from_basket do
      flash[:success] = I18n.t("mercator.messages.lineitem.delete.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_transfer_to_basket
    do_transition_action :transfer_to_basket do
      flash[:success] = I18n.t("mercator.messages.lineitem.transfer.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_add_one
    do_transition_action :add_one do
      flash[:success] = I18n.t("mercator.messages.lineitem.increase_amount.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_remove_one
    do_transition_action :remove_one do
      flash[:success] = I18n.t("mercator.messages.lineitem.decrease_amount.success")
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_enable_upselling
    do_transition_action :enable_upselling do
      redirect_to session[:return_to]
    end
  end

  def do_disable_upselling
    do_transition_action :disable_upselling do
      redirect_to session[:return_to]
    end
  end
end