class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def configure_permitted_parameters
    # sign_up時に許可するパラメータの追加
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name])
    # または login 時や account_update 時にも必要なら追加可能
    # devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name])
  end
end
