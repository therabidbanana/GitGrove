require 'cgi'


class Layouts::Main < Mustache::Rails
  include Rack::Utils
  alias_method :h, :escape_html

  attr_reader :name

  def escaped_name
    CGI.escape(@name)
  end

  def title
    "Home"
  end
end

