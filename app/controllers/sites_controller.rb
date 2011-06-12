class SitesController < ApplicationController
  before_filter :authenticate_user!
  def dashboard
    @sites = Site.all
  end

  def new
    admin_only!
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])
    if(@site.save)
      redirect_to dashboard_path
    else
      redirect_to dashboard_path
    end
  end
  def destroy
    site = Site.find_by_id(params[:id])
    site.destroy
    redirect_to dashboard_path
  end
  
end
