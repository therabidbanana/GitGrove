# GitGrove

An easy way to host multiple Nanoc sites that auto update on git push and even
have a simple online interface for quick updates when you're away from your editor.

Note that as this project relies on Nanoc, and `nanoc compile` allows arbitrary 
code added to a lib dir, this may not be safe for environments where you don't trust
the people with Git access. The frontend interface only allows changes to content
items.

## Additional Setup

Sites are stored as repos, so you will need access to those repos. You can set up
a git user on your server to log in and push changes to the repos.

There is a configuration setting to allow you to set the storage path of repos,
we recommend you store them in your git user's home directory.

The Rails app will automatically set up a git hook (post-receive) to rebuild the nanoc site 
on a git push. The hook relies on curl, which you may need to install.

Each new repo is cloned from a template named _template_site.git in the
same directory as all the other sites are stored. (Default: Rails.root + 
'/gitsites'). A default template is included for testing (based on 
https://github.com/avdgaag/nanoc-template
), but you could set up any nanoc site as your default template.

Make sure to add a post-recieve hook that looks like this: 

```
  curl REBUILD_URL
```

The REBUILD_URL will be replaced with a url allowing the site to be
rebuilt whenever you create a new clone. Set the hook as non-executable
to avoid errors when pushing changes to _template_site. 


## Nanoc Building


To build, Nanoc is called from a shell chdir'd into a special site_preview folder.

Currently builds block the ui until the build is completed, so for big sites you may have issues.

As the `nanoc compile` command is executed from a subshell, the gems installed with 
the rails application will take priority over the Gemfile included with any nanoc site.
If you have multiple gemsets, add any necessary gems to build your Nanoc sites to the 
GitGrove Gemfile.


You must run a delayed job work to get builds. A procfile is provided
for testing so you can run the server and worker process with a single
command: `foreman start`

## Nanoc Preview

Previews are available at subdomains of the main app. This can be
a little tricky to set up in testing environments - /etc/hosts isn't
enough to handle dynamic subdomains. You'll either need to manually 
add them, or install a local dns server like dnsmasq.

Previews can also be accessed by including the subdomain as part of the
path (localhost/mysubdomain/index.html instead of
mysubdomain.localhost/index.html), but this is unreliable, and
assets that are linked to with absolute links won't work.


