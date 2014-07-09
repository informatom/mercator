# Be sure to restart your server when you modify this file.
#
# This file contains settings for ActionController::ParamsWrapper which
# is enabled by default.

# Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.

# HAS: 20140708: This was different in the new generared ember app ...
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json] if respond_to?(:wrap_parameters)
#  wrap_parameters format: [:json]
end

# HAS: 20140708: This was not enabled in the new generared ember app ...
# Disable root element in JSON by default.
ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = true
end
