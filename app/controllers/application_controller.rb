class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Devise の Strong Parameters を拡張し、
  # サインアップ時に name パラメータを許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  # ユーザー登録（サインアップ）後のリダイレクト先を指定
  # デフォルトでは自動ログイン
  # def after_sign_up_path_for(resource)
  # end

  # サインアウト後のリダイレクト先を指定
  # デフォルトではルートパスに遷移
  # def after_sign_out_path_for(resource_or_scope)
  # end
end
