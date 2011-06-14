class NanocServer
  def call(env)
    
    site = Site.find_by_url(env['gitgrove_site_url'])

    env['PATH_INFO'] = env['PATH_INFO'].gsub(/^\/#{site.url}/, '')
    
    @dir_app = Rack::Directory.new(File.join(site.preview_path, 'output'))
    @dir_app.call(env)
  end


  def current_user(request)
    @current_user ||= User.find_by_id(request.env['gitgrove_user_id']) if request.env['gitgrove_user_id']  
  end
  
  def user_signed_in?
    return 1 if current_user 
  end
    
  def authenticate_user!(req)
    if !current_user(req)
      #flash[:error] = 'You need to sign in before accessing this page!'
      resp = Rack::Response.new
      resp.redirect("http://local.host:9292/services/signin")
      resp
    else 
      nil
    end
  end


end

