class Admin::Imports::ProductsController < Admin::ImportsController

  def index
    @jobs = Delayed::Job.paginate( :page => params[:page] || 1, :per_page => params[:per_page] || 10, :order => "run_at ASC" )
    @total_entries = @jobs.total_entries

    if Delayed::Job.count == 0
      if Inventory.need_sync?
        flash.now[:error] = "WEBARTIKEL are NOT up-to-date. Sync necessary!"
      else
        flash.now[:info] = "WEBARTIKEL are up-to-date. No sync necessary!"
      end
    end

    respond_to do |format|
      format.html
      format.extxml
    end
  end

  def statistic
    @inventory_count = Inventory.count( :select => "DISTINCT( Artikelnummer ) " )
    @product_count = Product.count
  end

  def import_icecat_product_data
    raise ArgumentError unless params[:product_id]
    Delayed::Job.enqueue( IcecatJob.new( :import_icecat_xml_for_product, :product_id => params[:product_id] ) )
    redirect_to :action => :index
  end


  def import_icecat_data
    Delayed::Job.enqueue( IcecatJob.new( :import_icecat_xml_full ) )
    redirect_to :action => :index
  end

  def mirror_webartikel
    Delayed::Job.enqueue( MesonicJob.new( :mirror_webartikel ) )
    Delayed::Job.enqueue( MesonicJob.new( :create_inventory_products ) )
    redirect_to :action => :index
  end

  def sync_webartikel
    Delayed::Job.enqueue( MesonicJob.new( :sync_webartikel ) )
    Delayed::Job.enqueue( IcecatJob.new( :import_icecat_xml_full ) )
    redirect_to :action => :index
  end

  def import_icecat_meta
    Delayed::Job.enqueue( IcecatJob.new( :import_icecat_meta_data ) )
    redirect_to :action => :index
  end

  def show
    @jobs = Delayed::Job.find( params[:id])
    respond_to do |wants|
      wants.html
      wants.js { render :action => :show, :layout => false }
    end
  end
end