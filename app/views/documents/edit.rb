class Documents::Edit < Mustache::Rails
  def formats(selected = @page.format)
    return [{ :name     => "Markdown",
        :id       => "markdown",
        :selected => true}]
  end  
 
  attr_reader :page, :content

  def title
    "#{@page.title}"
  end

  def content
    @page.raw_text_data
  end

  def page_name
    @page.title || @page.name.gsub('-', ' ')
  end

  def footer
    if @footer.nil?
      if page = @page.footer
        @footer = page.raw_data
      else
        @footer = false
      end
    end
    @footer
  end

  def escaped_name
    @page.name
  end

  def edit_document_path
    site_document_path(@site, page.name)
  end

  def edit_document_form_tag
    form_tag(edit_document_path, :method => :put, :name => 'gollum-editor')
  end

  def sidebar
    if @sidebar.nil?
      if page = @page.sidebar
        @sidebar = page.raw_data
      else
        @sidebar = false
      end
    end
    @sidebar
  end

  def is_create_page
    false
  end

  def is_edit_page
    true
  end

  def format
    @format = (@page.format || false) if @format.nil?
    @format.to_s.downcase
  end
end
