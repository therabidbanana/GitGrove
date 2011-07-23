class Documents::New < Mustache::Rails
  def formats(selected = @page.format)
    return [{ :name     => "Markdown",
        :id       => "markdown",
        :selected => true}]
  end  


  attr_reader :page, :name

  def title
    "Create a new page"
  end
  
  def is_create_page
    true
  end
  
  def is_edit_page
    false
  end

  def content_types
    @repo.content_types.map{|k, v| {:val => k, :human => k.humanize}}
  end

  def create_document_path
    new_site_document_path(@site)
  end

  def pages_list_path
    site_documents_path(@site)
  end

  def create_document_form_tag
    form_tag(create_document_path, :method => :put, :name => 'gollum-editor')
  end

  def image_list(selected = nil)
    @repo.assets.select do |f|
      f.image?
    end.map do |f|
      my_path = f.path.gsub(/^#{@repo.page_file_dir}/, '')
      {:path => my_path, :name => f.name, :selected => my_path == selected}
    end
  end

  def assets_list(selected = nil)
    @repo.assets.map do |f|
      my_path = f.path.gsub(/^#{@repo.page_file_dir}/, '')
      {:path => my_path, :name => f.name, :selected => my_path == selected}
    end
  end

  
  def format
    @format = (@page.format || false) if @format.nil? && @page
    @format.to_s.downcase
  end

  def has_footer
    @footer = (@page.footer || false) if @footer.nil? && @page
    !!@footer
  end

  def has_sidebar
    @sidebar = (@page.sidebar || false) if @sidebar.nil? && @page
    !!@sidebar
  end

  def page_name
    (@name ||'New Page').gsub('-', ' ')
  end

  def formats
    super(:markdown)
  end
end
