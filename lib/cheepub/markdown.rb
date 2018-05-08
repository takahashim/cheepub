require 'kramdown'

module Cheepub
  class Markdown
    RUBY_PATTERN = /{([^}]+)\|([^}]+)}/
    TCY_PATTERN = /\^([\u0020-\u005d\u005f\u007e]+)\^/ ## \u005e is "^"

    def self.parse(filename, **params)
      Markdown.new(File.read(filename), params)
    end

    def initialize(text, **params)
      default_params = {template: File.join(File.dirname(__FILE__), "templates/bodymatter.html.erb"),
                        lang: "ja",
                        title: "content",
                        cssfile: "style.css",
                        generator: "Cheepub #{Cheepub::VERSION} with kramdown #{Kramdown::VERSION}",
                        input: "cheemarkdown",
                       }
      @params = default_params.merge(params)
      @text = text
    end

    def convert
      params = @params.dup
      params[:syntax_highlighter] = "coderay"
      Kramdown::Document.new(@text, params).to_html
    end

    def to_latex
      params = @params.dup
      params[:template] = File.join(File.dirname(__FILE__), "templates/bodymatter.tex.erb")
      params[:latex_headers] = %w{chapter section subsection subsubsection paragraph subparagraph}
      Kramdown::Document.new(@text, params).to_latex
    end

    alias_method :to_html, :convert

    def save_as(filename)
      html = convert
      File.write(filename, html)
    end
  end
end
