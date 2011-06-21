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
same directory as all the other sites belong. (Default: Rails.root + 
'/gitsites'). A default template is included for testing (based on 
https://github.com/avdgaag/nanoc-template
), but you could set up any nanoc site as your default template.

Make sure to add a post-recieve hook that looks like this: 

```
  curl REBUILD_URL
```


## Nanoc Building


To build, Nanoc is called from a shell chdir'd into a special site_preview folder.

Currently builds block the ui until the build is completed, so for big sites you may have issues.

As the `nanoc compile` command is executed from a subshell, the gems installed with 
the rails application will take priority over the Gemfile included with any nanoc site.
If you have multiple gemsets, add any necessary gems to build your Nanoc sites to the 
GitGrove Gemfile.


