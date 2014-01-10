class Admin::PageTemplatesController < Admin::AdminSiteController

  hobo_model_controller

  auto_actions :all

  def update
    hobo_update
    this.save_to_disk_and_restart
    restart_app
  end

  def create
    hobo_create
    this.save_to_disk_and_restart
  end

protected


end
