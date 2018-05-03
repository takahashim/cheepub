require 'kramdown'

module Cheepub
  class Markdown
    def self.parse(filename, **params)
      Markdown.new(File.read(filename), params)
    end

    def initialize(text, **params)
      default_params = {template: File.join(File.dirname(__FILE__), "templates/bodymatter.html.erb"),
                        lang: "ja",
                        title: "EPUB sample",
                        cssfile: "style.css",
                        generator: "Cheepub #{Cheepub::VERSION} with kramdown #{Kramdown::VERSION}",
                        input: "GFM",
                       }
      @params = default_params.merge(params)
      @text = text
    end

    def convert
      Kramdown::Document.new(@text, @params).to_html
    end

    alias_method :to_html, :convert

    def save_as(filename)
      html = convert
      File.write(filename, html)
    end
  end
end
