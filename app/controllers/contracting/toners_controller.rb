class Contracting::TonersController < ApplicationController
  require 'roo'

  hobo_model_controller
  auto_actions :all
  index_action :upload

  index_action :do_upload do
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


  index_action :grid_index do
    @toners = Toner.all

    render json: {
      status: "success",
      total: @toners.count,
      records: @toners.collect {
        |toner| {
          recid:          toner.id,
          article_number: toner.article_number,
          vendor_number:  toner.vendor_number,
          description:    toner.description,
          price:          toner.price,
          created_at:     toner.created_at.utc.to_i*1000,
          updated_at:     toner.updated_at.utc.to_i*1000
        }
      }
    }
  end
end