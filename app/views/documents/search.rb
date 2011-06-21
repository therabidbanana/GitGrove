class Documents::Search < Mustache::Rails
  attr_reader :content, :page, :footer, :results, :query

  def title
    "Search results for " + @query
  end

  def has_results
    !@results.empty?
  end
  
  def no_results 
    @results.empty?
  end

end
