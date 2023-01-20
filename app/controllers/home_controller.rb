class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  # GET /homes
  # GET /homes.json
  def index
  end # index

  def dashboard
  end
  
  def show
    render template: "home/#{params[:page]}"
  end
end # class
