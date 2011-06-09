require "grit"
require 'fileutils'


module GitHelpers
  def create_template_repo
    r = Grit::Repo.init_bare(File.join(Yetting.repo_storage_path, "_template_site.git"))
    FileUtils.touch(File.join(Yetting.repo_storage_path, "_template_site.git", "hooks", "testing-custom-hook"))
  end

  def repo_exists?(repo_name)
    File.exists?(File.join(Yetting.repo_storage_path, "#{repo_name}.git")) 
  end

  def repo_inherits_hook?(repo_name)
    File.exists?(File.join(Yetting.repo_storage_path, "#{repo_name}.git", "hooks", "testing-custom-hook"))
  end
end
World(GitHelpers)
