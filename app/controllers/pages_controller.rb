class PagesController < ApplicationController
  PAGES = /index|about/
  def index
    render 'index'
  end

  def about
    render 'about'
  end

  def show
    render :action => params[:page]
  end
end
