require "grit"
require 'fileutils'


module GitHelpers
  def clean_out_sites_dir
    FileUtils.rm_rf(Yetting.repo_storage_path)
    FileUtils.rm_rf('/tmp/gitgrovetest')

    FileUtils.mkdir(Yetting.repo_storage_path)
    FileUtils.mkdir('/tmp/gitgrovetest')

  end
  def create_template_repo
    r = Grit::Repo.init_bare(File.join(Yetting.repo_storage_path, "_template_site.git"))
    FileUtils.touch(File.join(Yetting.repo_storage_path, "_template_site.git", "hooks", "testing-custom-hook"))
  end

  def push_from(path)
    Grit::Git.new(path).push
  end

  def create_working_template
    FileUtils.cp_r(File.join(Rails.root, "git_sites", "_template_site.git"), File.join(Yetting.repo_storage_path, "_template_site.git"))
  end

  def repo_exists?(repo_name)
    File.exists?(File.join(Yetting.repo_storage_path, "#{repo_name}.git")) 
  end

  def working_clone_for(site)
    clone = Grit::Git.new('/tmp/').clone({}, site.repo_path, "/tmp/gitgrovetest/#{site.url}")
    clone
  end


  def edit_file(file_path, string)
    File.open(file_path, 'w') {|f| f.write(string) }
  end


  def commit_all_changes(file_path)
    Dir.chdir(file_path) do 
      system('git add .')
      system('git commit -m "Commit changes"')
    end
  end

  
  def push_changes(file_path)
    Dir.chdir(file_path) do 
      system('git push')
    end
  end


  def find_clone(site_url)
    clone = Grit::Repo.new("/tmp/gitgrovetest/#{site_url}")
  end
  def clone_path(site_url)
    "/tmp/gitgrovetest/#{site_url}"
  end

  def repo_inherits_hook?(repo_name)
    File.exists?(File.join(Yetting.repo_storage_path, "#{repo_name}.git", "hooks", "testing-custom-hook"))
  end
end
World(GitHelpers)
