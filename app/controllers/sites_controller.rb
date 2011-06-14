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
      # Fix hook
      hook_name = File.join(@site.repo_path, 'hooks', 'post-receive')
      rebuild_url = rebuild_site_url(@site, :token => @site.rebuild_token, :only_path => false)
      text = File.read(hook_name)
      
      text.gsub!(/REBUILD_URL/, rebuild_url)
      File.open(hook_name, "w") {|file| file.puts text}
      File.chmod(0755, hook_name)


      redirect_to dashboard_path
    else
      redirect_to dashboard_path
    end
  end

  def edit
    @site = Site.find_by_id(params[:id])
    
  end

  def rebuild
    @site = Site.find_by_id(params[:id])
    unless params[:token] == @site.rebuild_token
      redirect_to(dashboard_path) and return
    end
    @site.build!
    render :text => 'Rebuild successful!'
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
      request.params['site_url'] = s.url
      true
    else
      false
    end
  end 
end
