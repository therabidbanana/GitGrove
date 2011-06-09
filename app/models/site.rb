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
    self.save
  end

  def remove_repo
    FileUtils.rm_rf(self.repo_path) if self.repo_path
  end
end
