class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # Googleログインボタンのための認証元情報を保存
    session[:auth_origin] = 'email_password'
    super
  end

  # POST /resource/sign_in
  def create
    super do |user|
      if user.persisted?
        # ログイン成功時のログ記録
        Rails.logger.info "User #{user.email} logged in via email/password"
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    user_email = current_user&.email
    super do
      # ログアウト時のログ記録
      Rails.logger.info "User #{user_email} logged out"
    end
  end

  protected

  # サインイン失敗時の処理
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
