class UsersController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def edit; end

  def update
    current_user.update(user_params)
    if current_user.valid?
      flash[:success] = "Successfully updated your profile."
    else
      flash[:error] = current_user.errors.messages.to_s
    end

    redirect_to user_index_path(current_user)
  end

private

  def user_params
    params.require(:user).
      permit(:email, :name, :password, :password_confirmation)
  end
end
