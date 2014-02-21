class OffersController < ApplicationController

  hobo_model_controller

  auto_actions :show, :lifecycle

  def refresh
    self.this = Offer.find(params[:id])
    hobo_show
  end

end