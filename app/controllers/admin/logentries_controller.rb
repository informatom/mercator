class Admin::LogentriesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def index
    logentries = Logentry
    if params[:sort]
      sortparam = params[:sort]["0"][:field] == "recid" ? "id" : params[:sort]["0"][:field]
      sortparam ||= :id
      direction = "DESC"
      direction = "ASC" if params[:sort]["0"][:direction] == "asc"
      logentries = logentries.order(sortparam + ' ' + direction)
    end
    if params[:search]
        logentries = logentries.where("#{params[:search]["0"][:field]} LIKE '%#{params[:search]["0"][:value]}%'")
    end
    total = logentries.count
    logentries = logentries.limit(params[:limit] || 100)
                           .offset(params[:offset] || 0)

    respond_to do |format|
      format.html { respond_with [] }
      format.json {
        render json: {
          status: "success",
          total: total,
          records: logentries.collect {
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
end