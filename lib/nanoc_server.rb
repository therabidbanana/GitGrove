require 'adsf'

class NanocServer
  def call(env)
    
    site = Site.find_by_url(env['gitgrove_site_url'])

    env['PATH_INFO'] = env['PATH_INFO'].gsub(/^\/#{site.url}/, '') unless env['gitgrove_site_by_domain']
    
    @dir_app = Rack::Directory.new(File.join(site.preview_path, 'output'))
    @index_app = Adsf::Rack::IndexFileFinder.new(@dir_app, :root => File.join(site.preview_path, 'output'))
    status, headers, body = @index_app.call(env)
    if(status == 200)
      new_body = ""
      body.each{|str| new_body += str }
      new_body.gsub!(/(<body[^>]*>)/, "\1#{build_status(site)}")
      Rack::Response.new(new_body, status, headers).finish
    else
      [status, headers, body]
    end
    
  end

  def build_status(site)
    if(site.error?)
      '<div style="width:100%; background: rgba(220,0,0, 0.8);padding: 1em;position:fixed;top:0;">(Build error)</div>'
    elsif(!site.built?)
      '<div style="width:100%; background: rgba(250,250,150, 0.8);padding: 1em;position:fixed;top:0;">(Site rebuilding, check again in a moment)</div>'
    else
      ''
    end
  end



end

