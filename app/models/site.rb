require 'grit'
class Site < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_sites
  after_create :setup_repo


  def setup_repo
    self.repo_path = "#{Yetting.repo_storage_path}/#{self.url}.git"
    clone = "#{Yetting.repo_storage_path}/_template_site.git"
    
    if(File.exists?(clone))
      Grit::Repo.new(clone).fork_bare(self.repo_path)
    else
      Grit::Repo.init_bare(self.repo_path)
    end
    self.save
  end
end
