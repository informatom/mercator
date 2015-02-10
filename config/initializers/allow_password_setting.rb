module Hobo
  module Model
    module UserBase

      def changing_password?
        !new_record? && !lifecycle_changing_password? &&
          ((current_password.present? && current_user.administrator?) || password.present? || password_confirmation.present?)
      end

    end
  end
end