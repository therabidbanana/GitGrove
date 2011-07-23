require 'stinker/frontend/app'
class DocumentsController < ApplicationController
  layout "main"
  before_filter :authenticate_user!
  def index
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
  end

  def show
    redirect_to edit_site_document_path(params[:site_id], params[:id])
  end

  def new
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @pages = @repo.pages
    @nesting = @pages.collect{|p| p.name unless p.name =~ /^[iI]ndex/}.compact
  end

  def create
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    redirect_to site_documents_path(@site)
  end

  def revert
    @site = Site.find_by_id(params[:site_id])
    site = @repo = Stinker::Site.new(@site.repo_path)
    @name = params[:id]
    @page = site.page(@name)
    sha1  = params[:before]
    sha2  = params[:after]

    if site.revert_page(@page, sha1, sha2, commit_for(@page))
      redirect_to edit_site_document_path(@site, @page.name)
    else
      sha2, sha1 = sha1, "#{sha1}^" if !sha2
      @versions = [sha1, sha2]
      diffs     = site.repo.diff(@versions.first, @versions.last, @page.path)
      @diff     = diffs.first
      @message  = "The patch does not apply."
      render 'do_compare'
    end
  end

  def history
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)

    @name     = params[:id]
    @page     = @repo.page(@name)
    @page_num = [params[:page].to_i, 1].max
    @versions = @page.versions :page => @page_num
  end

  def compare
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @versions = params[:versions] || []
    @name     = params[:id]
    @page     = @repo.page(@name)
    if @versions.size < 2
      redirect_to history_site_document_path(@site, params[:id])
    else
      redirect_to "#{site_document_path(@site, params[:id])}/do_compare/#{@versions.last}...#{@versions.first}"
    end
  end

  def do_compare
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @name     = params[:id]
    @page     = @repo.page(@name)
    @versions = params[:versions].split(/\.{2,3}/)
    diffs     = @repo.repo.diff(@versions.first, @versions.last, @page.path)
    @diff     = diffs.first
  end

  def edit
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @name = params[:id]
    @page = @repo.page(@name)
    @pages = @repo.pages
    @nesting = @pages.collect{|p| p.name unless p.name =~ /^[iI]ndex/}.compact
    if @page

      @meta = @page.meta_data
    else
      @meta = {}
      @name = params[:id]
      render :new
      # redirect_to site_documents_path(@site)
    end
  end

  def update
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @name = params[:page_name] || params[:id] || params[:page_title]
    @name = params[:nested_in] + '/'+ @name if params[:nested_in]
    @page = @repo.page(params[:id])
    @meta = {'title' => params[:page_title]}

    @meta.merge!(params[:extras]) if params[:extras]
    if(@page)
      @repo.update_page_with_meta(@page, @name, @page.format, params[:content], @meta, commit_for(@page))
    else
      @name = params[:page_title].downcase if @name.empty? || @name == "new"
      @repo.write_page_with_meta(@name, :markdown, params[:content], @meta, commit_for(@page))
    end
    @site.start_build!
    redirect_to site_documents_path(@site)
  end

  def destroy
    @site = Site.find_by_id(params[:site_id])
    @repo = Stinker::Site.new(@site.repo_path)
    @page = @repo.page(params[:id])

    if(@page)
      @repo.delete_page(@page, commit_for(@page, "Deleting page - #{@page.name}"))
    end
    @site.start_build!
    redirect_to site_documents_path(@site)
  end

  private
    def commit_for(page, message = nil)
      if page
        {
            :name => current_user.name, 
            :email => current_user.email, 
            :message => (message || "Updating #{@page.name} page")
          }
      else
        {
            :name => current_user.name, 
            :email => current_user.email, 
            :message => (message || "Creating a new page")
          }
      end
    end

end
