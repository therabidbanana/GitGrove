require 'stinker/frontend/app'
class DocumentsController < ApplicationController
  layout "main"
  def index
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
  end
  def edit
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
    @page = @repo.page(params[:id])
  end
  def update
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
    @page = @repo.page(params[:id])
    @repo.update_page(@page, @page.name, @page.format, params[:content])
    redirect_to site_documents_path(@site)
  end
  
end
