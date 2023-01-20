class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /homes
  # GET /homes.json
  def index
  end # index
  
  def show
    render template: "home/#{params[:page]}"
  end
end # class
