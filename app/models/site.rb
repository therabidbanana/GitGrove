require 'grit'
require 'fileutils'
class Site < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_sites
  after_create :setup_repo
  before_destroy :remove_repo

  def setup_repo
    self.repo_path = "#{Yetting.repo_storage_path}/#{self.url}.git"
    clone = "#{Yetting.repo_storage_path}/_template_site.git"
    
    if(File.exists?(clone))
      Grit::Repo.init_bare(self.repo_path, :template => clone)
    else
      Grit::Repo.init_bare(self.repo_path)
    end

    if(!File.exists?(preview_path))
      FileUtils.mkdir(Yetting.preview_storage_path) if(!File.exists?(Yetting.preview_storage_path))
      git = Grit::Git.new(Yetting.preview_storage_path)
      git.clone({}, self.repo_path, preview_path)
    end

    self.save
    build!
  end

  def remove_repo
    FileUtils.rm_rf(self.repo_path) if self.repo_path
  end

  def preview_path
    "#{Yetting.preview_storage_path}/#{self.url}"
  end

  def self.matches?(request)
    first_path_part = request.fullpath.split('/')[1]
    s = ::Site.find_by_url(first_path_part)
    s = ::Site.find_by_url(request.host.split('.').first) unless s
    if(s)
      request.env['gitgrove_site_url'] = s.url
      request.params['site_url'] = s.url
      true
    else
      false
    end
  end

  def build!
    Dir.chdir(preview_path) do
      system "nanoc co"
    end
  end
end
