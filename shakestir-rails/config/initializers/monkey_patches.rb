Rails.application.config.to_prepare do
  require_relative "../../lib/core_extensions/actionview/lib/action_view/helpers/tag_helper.rb"
end
