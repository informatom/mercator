class Admin::PageTemplatesController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def update
    hobo_update
    this.save_to_disk
  end

  def create
    hobo_create
    this.save_to_disk
  end

  def restart
    exec("touch " + Rails.root.to_s + "/tmp/restart.txt &")
  end
end