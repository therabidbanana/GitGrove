class NanocServer
  def call(env)
    site = Site.find_by_url(env['gitgrove_site_url'])

    env['PATH_INFO'] = env['PATH_INFO'].gsub(/^\/#{site.url}/, '')
    
    @dir_app = Rack::Directory.new(File.join(site.preview_path, 'output'))
    @dir_app.call(env)
  end
end

