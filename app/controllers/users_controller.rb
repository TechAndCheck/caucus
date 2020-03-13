class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
  end

  def edit; end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.valid?
      flash[:success] = "Successfully updated your profile."

      # If a user changes their password Devise auto logs them out, that's dumb
      # Instead, just log them back in
      sign_in current_user, bypass: true

      redirect_to user_index_path(@user)
      return
    else
      error_string = "Saving your updates was stopped by #{@user.errors.count} #{"error".pluralize(@user.errors.count)}:"
      flash[:error] = error_message(error_string, @user.errors)
    end

    render :index
  end

private

  def user_params
    params.require(:user).
      permit(:email, :name, :password, :password_confirmation)
  end

  def error_message(text, errors)
    error_string = text
    error_string += "<ul>"

    errors.full_messages.each do |msg|
      error_string += "<li>#{msg}</li>"
    end
    error_string += "</ul>"
    error_string
  end
end
