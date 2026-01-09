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

  # ユーザー登録（サインアップ）完了後のリダイレクト先を指定
  # デフォルトでは自動ログインされるが、
  # 本アプリではログイン画面へ遷移
  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  # サインアウト後のリダイレクト先を指定
  # 以下を記述しなければ、ルートパスに遷移
  # def after_sign_out_path_for(resource_or_scope)
  # end
end
