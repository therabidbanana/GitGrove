module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/index.html'

    when /the dashboard/
      '/sites/dashboard'

    when /the new site page/
      new_site_path

    when /users page/
      '/users'

    when /the preview site for "(.*)"/
      uri = URI.parse(current_url)
      "#{uri.scheme}://#{$1}.#{uri.host}/index.html"

    when /the rebuild url for "(.*)"/
      rebuild_site_path(Site.find_by_url($1))
    when /the edit "(.*)" dashboard/
      site_documents_path(Site.find_by_url($1).id)
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

  def url_to(page_url)
    case page_url

    when /the preview site for "(.*)"/
      uri = URI.parse(current_url)
      host = uri.host =~ /^(#{$1}\.)/ ? uri.host : "#{$1}#{uri.host}"
      "#{uri.scheme}://#{host}/index.html"
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('url').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a url.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
