
def section_articles section
  re = Regexp.new("^/docs/#{section}/.*")
  @items.select {|i| re =~ i.identifier }
end
