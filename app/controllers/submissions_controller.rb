class SubmissionsController < ApplicationController

  hobo_model_controller
  auto_actions :new, :create

  def create
    hobo_create(redirect: new_submission_path) do
      if self.this.valid?
        UserMailer.submission(@submission).deliver
      end
    end
  end
end