class Contracting::TonersController < Contracting::ContractingSiteController
  require 'roo'

  hobo_model_controller
  auto_actions :all
  index_action :upload

  index_action :do_upload do
    Toner.delete_all

    @liste =  Roo::Spreadsheet.open(params[:xlsx].path, extension: :xlsx)

    @liste.each_with_index do |row, index|
      next if index == 0
      @toner = Toner.find_or_initialize_by(vendor_number: row[1])
      @toner.update(article_number: row[0], description: row[2], price: row[3])
      puts @toner.errors.first
    end

    redirect_to contracting_toners_path
  end
end