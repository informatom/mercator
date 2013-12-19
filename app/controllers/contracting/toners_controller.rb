class Contracting::TonersController < ApplicationController
  require 'spreadsheet'
    Spreadsheet.client_encoding = 'UTF-8'

  hobo_model_controller

  auto_actions :all
  index_action :upload, :do_upload

  def do_upload
  end

end