# see http://forrst.com/posts/Setting_up_SASS_on_Heroku-4dZ

# You can put this in config/initializers/sass.rb

# Setup directory in tmp/ to dump the generated css into 
require "fileutils"
FileUtils.mkdir_p(Rails.root.join("tmp", "stylesheets", "generated"))

# Tell SASS to use the .sass files in public/stylesheets/sass and 
# output the css to tmp/stylesheets/generated
Sass::Plugin.options[:template_location] = {
  'app/stylesheets' => 'tmp/stylesheets'
}

# Use Rack::Static to point all requests beginning 
# with /stylesheets to the tmp/ dir
# see http://devcenter.heroku.com/articles/using-compass

# It's okay for developer to have CSS generated inside tmp/

Rails.configuration.middleware.delete('Sass::Plugin::Rack')
Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Sass::Plugin::Rack')

Rails.configuration.middleware.insert_before('Rack::Sendfile', 'Rack::Static',
    :urls => ['/stylesheets'],
    :root => "#{Rails.root}/tmp")

