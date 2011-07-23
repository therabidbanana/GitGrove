require 'cgi'


class Layouts::Main < Mustache::Rails
  include Rack::Utils
  alias_method :h, :escape_html

  attr_reader :name

  def escaped_name
    CGI.escape(@name)
  end

  def title
    t :app_name
  end

  def location
    @location_id || "site_edit"
  end

  def stylesheets
    stylesheet_link_tag "styles"
  end

  def is_admin
    current_user && current_user.admin?
  end

  def current_user
    user_signed_in?
  end

  def js_rails
    javascript_include_tag 'rails'
  end
end

