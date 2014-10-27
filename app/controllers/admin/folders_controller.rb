class Admin::FoldersController < Admin::AdminSiteController

  hobo_model_controller
  auto_actions :all

  def update
    hobo_update(redirect: contentmanager_front_path) do
      session[:selected_folder_id] = this.id
    end
  end

  def create
    hobo_create(redirect: contentmanager_front_path) do
      session[:selected_folder_id] = this.id
    end
  end

  def destroy
    begin
      @folder = Folder.find(params[:id])
    rescue
      render :text => I18n.t("mercator.content_manager.cannot_delete_folder.record_not_found"),
             :status => 403 and return
    end

    if @folder.content_elements.any?
      render :text => I18n.t("mercator.content_manager.cannot_delete_folder.content_elements"),
             :status => 403 and return
    elsif @folder.children.any?
      render :text => I18n.t("mercator.content_manager.cannot_delete_folder.subfolders"),
      :status => 403 and return
    end

    hobo_destroy do
      render nothing: true if request.xhr?
    end
  end
end