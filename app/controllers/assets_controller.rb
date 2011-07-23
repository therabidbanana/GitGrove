class AssetsController < ApplicationController
  def index
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
  end

  def destroy
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @file = @repo.file(params[:id])
    if @file
      @repo.delete_file(@file, commit_for(@file))
    end
    redirect_to site_assets_path(@site)
  end

  def new
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
  end

  def update
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @file = params[:file]
    @data = @file.read
    begin
      @repo.write_file(@file.original_filename, @data, commit_for(nil))
    rescue Stinker::DuplicatePageError => e
      randomized = rand(36**4).to_s(36)
      ext = File.extname(@file.original_filename)
      base = File.basename(@file.original_filename, ext)
      new_name = base + '-' + randomized + ext
      @repo.write_file(new_name, @data, commit_for(nil))
    end
    redirect_to site_assets_path(@site)
  end

 private
    def commit_for(file, message = nil)
      if file
        {
            :name => current_user.name, 
            :email => current_user.email, 
            :message => (message || "Deleting #{@file.name}")
          }
      else
        {
            :name => current_user.name, 
            :email => current_user.email, 
            :message => (message || "Adding a new file")
          }
      end
    end
end
