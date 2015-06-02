class Admin::ProductsController < Admin::AdminSiteController

  hobo_model_controller

  skip_before_filter :admin_required
  before_filter :productmanager_required

  auto_actions :all
  index_action :catch_orphans, :index_invalid, :reindex

  autocomplete :number


  def index
    if params[:search].present?
      @search = params[:search].split(" ").map{|word| "%" + word + "%"}
      self.this = Product.paginate(:page => params[:page])
                          .where{(title_de.matches_any my{@search}) |
                                 (title_en.matches_any my{@search}) |
                                 (state.matches_any my{@search}) |
                                 (number.matches_any my{@search}) }
                         .order_by(parse_sort_param(:title_de, :title_en, :this, :number, :state))
    else
      self.this = Product.paginate(:page => params[:page])
                         .order_by(parse_sort_param(:title_de, :title_en, :this, :number, :state))
    end
    hobo_index
  end


  def catch_orphans
    JobLogger.info("=" * 50)
    JobLogger.info("Started Task: products:catch_orphans")
    Product.catch_orphans
    JobLogger.info("Finished Task: products:catch_erphans")
    JobLogger.info("=" * 50)

    redirect_to admin_logentries_path
  end


  def index_invalid
    @errorsarray = Product.all.reject{|p| p.valid?}.map{|p| [p.id, p.errors.messages]}
  end


  def reindex
    JobLogger.info("=" * 50)
    JobLogger.info("Started Task: products:reindex")
    Product.reindex
    JobLogger.info("Finished Task: products:reindex")
    JobLogger.info("=" * 50)

    redirect_to admin_logentries_path
  end
end