class Documents::Edit < Mustache::Rails
  def formats(selected = @page.format)
    return [{ :name     => "Markdown",
        :id       => "markdown",
        :selected => true}]
  end  
 
  attr_reader :page, :content, :name

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

  
  def content_types
    @repo.content_types
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


  def meta_fields
    type = @page.meta_data ? (@page.meta_data["content_type"] || "page") : "page"
    fields = @repo.content_types[type] || {}
    fields.collect do |field, value_type|
      my_val =  (@page.meta_data ? (@page.meta_data[field] || "") : "")
      {"field_name" => field, 
        "human_field_name" => field.humanize, 
        "field_value" => my_val
      }.merge(field_info(value_type, my_val))
    end
  end

  def field_info(type, val = nil)
    case type
    when "text"
      {"is_text" => true, "field_type" => "text"}
    when "fulltext"
      {"is_fulltext" => true, "field_type" => "fulltext"}
    when "image"
      {"is_image" => true, "field_type" => "image", "field_image_list" => image_list(val)}
    when "asset"
      {"is_asset" => true, "field_type" => "asset", "field_assets_list" => assets_list(val)}
    else
      {"field_type" => "unknown"}
    end
  end

  def has_meta_fields
    meta_fields.size > 0
  end
  def preview_url
    with_subdomain(@site.url)
  end

  def escaped_name
    @page.fullname
  end
  def pages_list_path
    site_documents_path(@site)
  end

  def content_type
    @meta ||= {}
    (@meta["content_type"].nil? || @meta["content_type"].empty?) ? "page" : @meta["content_type"] 
  end
  
  def history_document_path
    history_site_document_path(@site, @page.fullname)
  end

  def edit_document_path
    site_document_path(@site, page.fullname)
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
