class Contracting::UsersController < Contracting::ContractingSiteController

  hobo_model_controller
  auto_actions :all, except: :destroy

  index_action :grid_index do
    if params[:only_consultants] == "true"
      @users = User.where{(sales == true) | (sales_manager == true) }
    else
      @users = User.all
    end

    render json: {
      status: "success",
      total: @users.count,
      records: @users.collect {
        |user| {
          recid:            user.id,
          gender:           user.gender,
          title:            user.title,
          first_name:       user.first_name,
          surname:          user.surname,
          email_address:    user.email_address,
          phone:            user.phone,
          administrator:    user.administrator,
          sales:            user.sales,
          sales_manager:    user.sales_manager,
          contentmanager:   user.contentmanager,
          productmanager:   user.productmanager,
          last_login_at:    user.last_login_at,
          logged_in:        user.logged_in,
          login_count:      user.login_count,
          gtc_confirmed_at: user.gtc_confirmed_at,
          gtc_version_of:   user.gtc_version_of,
          erp_account_nr:   user.erp_account_nr,
          erp_contact_nr:   user.erp_contact_nr,
          locale:           user.locale,
          call_priority:    user.call_priority,
          waiting:          user.waiting,
          editor:           user.editor,
          created_at:       user.created_at.utc.to_i*1000,
          updated_at:       user.updated_at.utc.to_i*1000
        }
      }
    }
  end
end