class SitesController < ApplicationController
  before_filter :authenticate_user!, :except => [:rebuild]
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

  def rebuild
    @site = Site.find_by_id(params[:id])
    @site.build!
    render 
  end
  def destroy
    site = Site.find_by_id(params[:id])
    site.destroy
    redirect_to dashboard_path
  end



  def matches?(request)
    first_path_part = request.fullpath.split('/')[1]
    s = Site.find_by_url(first_path_part)
    s = Site.find_by_url(request.host.split('.').first) unless s
    if(s)
      request.env['gitgrove_site_url'] = s.url
      request.env['gitgrove_user_id'] = request.session[:user_id]
      request.params['site_url'] = s.url
      true
    else
      false
    end
  end 
end
