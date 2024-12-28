class Users::RegistrationsController < Devise::RegistrationsController
  layout 'devise'

  # 必要に応じてアクションをオーバーライド可能
  # def new
  #   super
  # end
end
