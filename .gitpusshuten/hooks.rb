##
# Git Pusshu Ten - Hooks
#
# These are actions performed on the remote server
# from within the application root. Depending on what
# modules you included in the "config.rb" file, you might
# not have to create extra hooks here.
#
# For example, if you specified the :nginx module in the "config.rb"
# then you do not need to specify a nginx restart hook here since the
# module will automatically add a hook that already does that for you.
#
# For more information, visit:
# http://secretpreview.gitpusshuten.com/documentation/getting-started/deployment-hooks/

perform_on :staging, :production do
  # pre "Echo out something" do
  #   run 'echo "Ready to Deploy"'
  # end
end

perform_on :staging do
  # post "Display application root directory contents" do
  #   run 'ls -la'
  # end

  # post "Restart NginX" do
  #   run '/etc/init.d/nginx restart'
  # end
end

perform_on :production do
  # post "Display application root directory contents" do
  #   run 'ls -la'
  # end

  # post "Restart NginX" do
  #   run '/etc/init.d/nginx restart'
  # end
end