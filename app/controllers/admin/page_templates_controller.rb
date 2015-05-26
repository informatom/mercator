class Admin::PageTemplatesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def edit
    if params[:version]
      self.this = @page_template = PageTemplate.find(params[:id]).versions.find(params[:version]).reify
    end
    hobo_show
  end

  def update
    hobo_update
    this.save_to_disk if this.name
  end

  def create
    hobo_create
    this.save_to_disk if this.name
  end

  def restart
    exec("touch " + Rails.root.to_s + "/tmp/restart.txt &")
  end
end