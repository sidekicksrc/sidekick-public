usage       'posts [options]'
aliases     :ps, :posts
summary     'a summary of posts'
description 'Shows posts, word counts, last edited, etc'

flag   :h, :help,  'show help for this command' do |value, cmd|
  puts cmd.help
  exit 0
end

run do |opts, args, cmd|
  puts self.site.items
end

class ShowPosts < ::Nanoc::CLI::CommandRunner
  def run
    self.require_site
    self.site.compile
    articles = self.site.items.select do |item|
      /\/posts\// =~ item.identifier
    end
    output articles
  end

  protected

  def output articles
    PostsTable.new(articles).run
  end
end

module WC
  def self.count html
    require "nokogiri"
    Nokogiri::HTML(html).inner_text.gsub(/[^\w ]/,"").squeeze(" ").split(" ").length
  end
end

require "command_line_reporter"
class PostsTable
  include CommandLineReporter

  def initialize posts
    @posts = posts
  end

  def c *args
    @c ||= Nanoc::CLI::ANSIStringColorizer
    @c.c *args
  end

  def run
    table do
      row header: true do
        column("Title",width: 80)
        column("~Words",align: "right",padding: 1)
        column("Created at")
        column("Published")
      end
      @posts.each do |post|
        row do
          column(post[:title] || post.identifier)
          column(WC.count(post.compiled_content))
          column(post[:created_at])
          column(post[:published] ? c("✔",:green) : c("✖",:red))
        end
      end
    end
  end
end

runner ShowPosts
