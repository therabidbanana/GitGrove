require 'stinker/frontend/app'
class DocumentsController < ApplicationController
  layout "main"
  before_filter :authenticate_user!
  def index
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
  end
  def edit
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
    
    @page = @repo.page(params[:id])
    @meta = @page.meta_data
  end
  def update
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
    @page = @repo.page(params[:id])
    @meta = {'title' => params[:page_title]}
    @repo.update_page_with_meta(@page, @page.name, @page.format, params[:content], @meta, commit_for(@page))
    @site.start_build!
    redirect_to site_documents_path(@site)
  end

  private
    def commit_for(page)
          {
            :name => current_user.name, 
            :email => current_user.email, 
            :message => "Updating #{@page.name}"
          }
    end

end
