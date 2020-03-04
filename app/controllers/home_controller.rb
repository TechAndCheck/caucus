class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:instructions]
  def index; end
  def instructions; end
end
