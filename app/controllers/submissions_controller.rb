class SubmissionsController < ApplicationController
  after_filter :track_action

  hobo_model_controller
  auto_actions :new, :create


  def create
    hobo_create(redirect: new_submission_path) do
      if self.this.valid?
        UserMailer.new_submission(self.this).deliver_now
      end
    end
  end
end