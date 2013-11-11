require "map"
include Nanoc::Helpers::Rendering
include Nanoc::Helpers::Blogging
def slug item
  item[:slug] || string_to_slug(item[:title])
end

def string_to_slug string
  string.strip.downcase.gsub(/[^\w_\- ]/,"").squeeze(" ").gsub(" ","-").squeeze("-")
end

require "nokogiri"
def first_paragraph html
  doc = Nokogiri::HTML(html)
  candidates = doc.css(".intro") + doc.css("p")
  return "" if candidates.empty?
  "<p>#{candidates.first.content}</p>"
end
def replace_tags html,a,b
  doc = Nokogiri::HTML(html)
  doc.css(a).each {|tag| tag.name = b }
  doc.to_html
end

AUTO_URLS = {
  /wikipedia\.org$/ => "Wikipedia",
  /martinfowler\.com$/ => "Martin Fowler",
  /^c2\.com$/ => "C2 Wiki"
}

def escape_link str
  str.gsub('"','\\"')
end

def resource_links resources, item
  err = "Resources should be a hash or a valid URL from a known source"
  resources.map do |res|
    case res
    when Hash
      begin
        res = Map.new(res)
        "<a href='#{escape_link res.fetch(:url)}'>#{res.fetch(:text)}</a>"
      rescue StandardError => e
        raise err + ": resource has keys #{res.keys}"
      end
    when String
      begin
        url = URI.parse(res)
        shortcut_name = AUTO_URLS.keys.find do |k|
          k =~ url.hostname
        end
        "<a href=\"#{escape_link res}\">#{AUTO_URLS.fetch(shortcut_name)} - #{item[:title]}</a>"
      rescue StandardError => e
        throw err + ", for hostname #{url.hostname} #{e}"
      end
    else
      throw err
    end
  end
end
