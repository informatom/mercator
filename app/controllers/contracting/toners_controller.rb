class Contracting::TonersController < ApplicationController
  require 'roo'

  hobo_model_controller

  auto_actions :all
  index_action :upload, :do_upload

  def do_upload
    @liste =  Roo::CSV.new(params[:xls].path, csv_options: {
                                                encoding: Encoding::UTF_16LE,
                                                col_sep: "\t",
                                                row_sep: "\r\n"})

    @liste.each_with_index do |row, index|
      next if index == 0
      @toner = Toner.find_or_initialize_by(vendor_number: row[4])
      @toner.update(article_number: row[2], description: row[3], price: row[8])
      puts @toner.errors.first
    end
  end
end