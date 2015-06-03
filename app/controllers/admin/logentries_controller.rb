class Admin::LogentriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def index
    @logentries = Logentry

    if params[:sort]
      sortparam =
        if params[:sort]["0"][:field] == "recid"
          "id"
        else
          params[:sort]["0"][:field]
        end
      sortparam ||= :id

      direction =
        if params[:sort]["0"][:direction] == "asc"
          "ASC"
        else
          "DESC"
        end

      @logentries = @logentries.order(sortparam + ' ' + direction)
    end

    if params[:search]
      @logentries = @logentries.where("#{params[:search]["0"][:field]} LIKE '%#{params[:search]["0"][:value]}%'")
    end

    total = @logentries.count
    @logentries = @logentries.limit(params[:limit] || 100)
                           .offset(params[:offset] || 0)

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: total,
          records: @logentries.collect {
            |logentry| {
              recid:          logentry.id,
              severity:       logentry.severity,
              message:        logentry.message,
              created_at:     I18n.l(logentry.created_at, format: :sortable),
            }
          }
        }
      }
    end
  end


  def destroy
    hobo_destroy do
      render json: { status: "success" } if request.xhr?
    end
  end
end