require 'yaml'

module Cheepub
  class Content
    using Cheepub::ExtHash

    SEPARATOR_PATTERN = /\n\n(?:\={3,}|\-{6,})\s*\n\n/m
    FRONTMATTER_PATTERN = /\A---$(.*?)^---\n/m

    attr_reader :src
    attr_reader :header
    attr_reader :body
    attr_reader :pages

    def initialize(content)
      @content = content
      @header, @body = parse_frontmatter(@content)
      @pages = separate_pages(@body)
    end

    def converted_pages(target = :to_html)
      @pages.map{ |page| Cheepub::Markdown.new(page).__send__(target) }
    end

    def each_content_with_filename(ext)
      if ext == "xhtml"
        target = :to_html
      elsif ext == "tex"
        target = :to_latex
      else
        raise Cheepub::Error, "invalid ext: #{ext}"
      end
      converted_pages(target).each_with_index do |page, idx|
        yield page, "bodymatter_#{idx}.#{ext}"
      end
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

    def parse_frontmatter(src)
      header = body = nil
      if src =~ FRONTMATTER_PATTERN
        header, body = YAML.safe_load($1).symbolize_keys!, $'
      else
        header, body = Hash.new(), src
      end
      return header, body
    end
  end
end
