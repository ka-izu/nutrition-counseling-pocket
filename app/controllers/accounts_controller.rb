class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @account = current_user
  end

  def edit
    @account = current_user
  end

  def update
    @account = current_user
    if @account.update(account_params)
      redirect_to account_path,
      notice: t("defaults.flash_message.updated", item: "アカウント情報")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account = current_user
    @account.destroy!

    redirect_to root_path,
      notice: t("defaults.flash_message.deleted", item: "アカウント")
  end

  private

  def account_params
    params.require(:user).permit(:name, :email)
  end
end
