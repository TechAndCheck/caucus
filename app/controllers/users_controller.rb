class UsersController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def edit; end

  def update; end

private

  def user_params
    params.require(:user).
      permit(:email, :password, :password_confirmation)
  end
end
