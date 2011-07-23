class Documents::History < Mustache::Rails
  attr_reader :page, :page_num

  def title
    @page.title
  end

  def versions
    i = @versions.size + 1
    @versions.map do |v|
      i -= 1
      { :id       => v.id,
        :id7      => v.id[0..6],
        :num      => i,
        :selected => @page.version.id == v.id,
        :author   => v.author.name,
        :message  => v.message,
        :date     => v.committed_date.strftime("%B %d, %Y"),
        :gravatar => Digest::MD5.hexdigest(v.author.email) }
    end
  end

  def history_document_path
    history_site_document_path(@site, @page.fullname)
  end

  def preview_url
    with_subdomain(@site.url)
  end

  def edit_document_path
    edit_site_document_path(@site, page.fullname)
  end

  def compare_document_path
    compare_site_document_path(@site, page.fullname)
  end

  def compare_document_form_tag
    form_tag(compare_document_path, :method => :post, :name => 'compare-versions', :id => 'version-form')
  end

  def escaped_name
    @page.fullname
  end

  def pages_list_path
    site_documents_path(@site)
  end


  def previous_link
    label = "&laquo; Previous"
    if @page_num == 1
      %(<span class="disabled">#{label}</span>)
    else
      %(<a href="#{history_document_path}?page=#{@page_num-1}" hotkey="h">#{label}</a>)
    end
  end

  def next_link
    label = "Next &raquo;"
    if @versions.size == Stinker::Page.per_page
      %(<a href="#{history_document_path}?page=#{@page_num+1}" hotkey="l">#{label}</a>)
    else
      %(<span class="disabled">#{label}</span>)
    end
  end
end
