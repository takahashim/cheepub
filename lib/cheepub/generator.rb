require 'securerandom'
require 'yaml'
require 'gepub'

module Cheepub
  class Generator
    using Cheepub::ExtHash

    SEPARATOR_PATTERN = /\n\n={3,}\s*\n\n/m
    FRONTMATTER_PATTERN = /\A---$(.*)^---\n/m

    def initialize(src, params = Hash.new)
      @src = src
      @params = params
    end

    def execute
      content = File.read(@src)
      head, body = parse_frontmatter(content)
      pages = separate_pages(body)
      html_pages = pages.map do |page|
        md = Cheepub::Markdown.new(page)
        md.convert
      end
      params = @params.merge(head)
      gbook = GEPUB::Book.new do |book|
        book.identifier = params[:id] || "urn:uuid:#{SecureRandom.uuid}"
        book.title = params[:title]
        book.creator = params[:author]
        book.language = params[:language] || 'ja'
        book.version = '3.0'
        File.open(File.join(File.dirname(__FILE__), "templates/style.css.erb")) do |f|
          item = book.add_item("style.css")
          item.add_content(f)
        end
        book.ordered do
          html_pages.each_with_index do |page, idx|
            item = book.add_item("bodymatter_0_#{idx}.xhtml")
            item.add_content(StringIO.new(page))
          end
        end
      end
      epubname = params[:epubname] || "book.epub"
      gbook.generate_epub(epubname)
    end

    def parse_frontmatter(src)
      head = body = nil
      if src =~ FRONTMATTER_PATTERN
        head, body = YAML.safe_load($1).symbolize_keys!, $'
      else
        head, body = Hash.new(), src
      end
      return head, body
    end

    def separate_pages(body)
      pages = nil
      if body =~ SEPARATOR_PATTERN
        pages = body.split(SEPARATOR_PATTERN)
      else
        pages = [body]
      end
      pages.each_with_index do |page, idx|
        if idx < pages.size - 1
          page.concat("\n")
        end
      end
      pages
    end
  end
end
