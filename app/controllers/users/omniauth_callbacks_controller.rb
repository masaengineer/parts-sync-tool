class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    provider = "google"
    # OAuthからの認証データをログ出力
    Rails.logger.debug "==== OAuth認証データ ===="
    Rails.logger.debug "Provider: #{provider}"
    Rails.logger.debug "Auth Data: #{request.env["omniauth.auth"].to_json}"

    @user = User.from_omniauth(request.env["omniauth.auth"])

    # ユーザー情報をログ出力
    Rails.logger.debug "==== ユーザー情報 ===="
    Rails.logger.debug "User: #{@user.attributes.to_json}"
    Rails.logger.debug "Persisted?: #{@user.persisted?}"

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success, kind: "#{provider}")
        Rails.logger.debug "認証成功: #{@user.email}"
      end
    else
      Rails.logger.debug "認証失敗: ユーザーの永続化に失敗"
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url
    end
  end

  def failure
    Rails.logger.debug "==== OAuth認証失敗 ===="
    Rails.logger.debug "Reason: #{failure_message}"
    redirect_to root_path
  end
end
