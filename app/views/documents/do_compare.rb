class Documents::DoCompare < Mustache::Rails
  attr_reader :page, :diff, :versions, :message

  def title
    "Comparison of #{@page.title}"
  end

  def page_title
    @page.title
  end

  def escaped_name
    @page.fullname
  end

  def history_document_path
    history_site_document_path(@site, @page.fullname)
  end

  def revert_document_path
    revert_site_document_path(@site, @page.fullname)
  end

  def revert_document_form_tag
    %|
      #{form_tag(revert_document_path, :method => :post, :id => 'gollum-revert-form', :name => 'gollum-revert')}
      <input type="hidden" name="before" value="#{before}" />
      <input type="hidden" name="after" value="#{after}" />
    |
  end

  def path
    @page.path
  end

  def pages_list_path
    site_documents_path(@site)
  end

  def before
    @versions[0][0..6]
  end

  def after
    @versions[1][0..6]
  end

  def lines
    lines = []
    @diff.diff.split("\n")[2..-1].each_with_index do |line, line_index|
      lines << { :line  => line,
                 :class => line_class(line),
                 :ldln  => left_diff_line_number(0, line),
                 :rdln  => right_diff_line_number(0, line) }
    end if @diff
    lines
  end

  def show_revert
    !@message
  end

  # private

  def line_class(line)
    if line =~ /^@@/
      'gc'
    elsif line =~ /^\+/
      'gi'
    elsif line =~ /^\-/
      'gd'
    else
      ''
    end
  end

  @left_diff_line_number = nil
  def left_diff_line_number(id, line)
    if line =~ /^@@/
      m, li = *line.match(/\-(\d+)/)
      @left_diff_line_number = li.to_i
      @current_line_number = @left_diff_line_number
      ret = '...'
    elsif line[0] == ?-
      ret = @left_diff_line_number.to_s
      @left_diff_line_number += 1
      @current_line_number = @left_diff_line_number - 1
    elsif line[0] == ?+
      ret = ' '
    else
      ret = @left_diff_line_number.to_s
      @left_diff_line_number += 1
      @current_line_number = @left_diff_line_number - 1
    end
    ret
  end

  @right_diff_line_number = nil
  def right_diff_line_number(id, line)
    if line =~ /^@@/
      m, ri = *line.match(/\+(\d+)/)
      @right_diff_line_number = ri.to_i
      @current_line_number = @right_diff_line_number
      ret = '...'
    elsif line[0] == ?-
      ret = ' '
    elsif line[0] == ?+
      ret = @right_diff_line_number.to_s
      @right_diff_line_number += 1
      @current_line_number = @right_diff_line_number - 1
    else
      ret = @right_diff_line_number.to_s
      @right_diff_line_number += 1
      @current_line_number = @right_diff_line_number - 1
    end
    ret
  end
end
