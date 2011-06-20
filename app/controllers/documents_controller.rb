require 'stinker/frontend/app'
class DocumentsController < ApplicationController
  def index
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
  end
  def edit
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path, :page_file_dir => 'content')
  end
end
