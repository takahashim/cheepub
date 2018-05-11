require 'kramdown'
require 'json'

module Cheepub
  class Markdown
    RUBY_PATTERN = /{([^}]+)\|([^}]+)}/
    TCY_PATTERN = /\^([\u0020-\u005d\u005f\u007e]+)\^/ ## \u005e is "^"

    def self.parse(filename, **params)
      Markdown.new(File.read(filename), params)
    end

    def initialize(text, **params)
      default_params = {template: File.join(Cheepub::TEMPLATES_DIR, "bodymatter.html.erb"),
                        lang: "ja",
                        title: "content",
                        cssfile: "style.css",
                        syntax_highlighter: nil,
                        generator: "Cheepub #{Cheepub::VERSION} with kramdown #{Kramdown::VERSION}",
                        input: "cheemarkdown",
                       }
      @params = default_params.merge(params)
      @text = text
    end

    def convert
      params = @params.dup
      params[:syntax_highlighter] = "rouge"
      Kramdown::Document.new(@text, params).to_html
    end

    def to_latex
      params = @params.dup
      params[:template] = File.join(Cheepub::TEMPLATES_DIR, "bodymatter.tex.erb")
      params[:latex_headers] = %w{chapter* section* subsection* subsubsection* paragraph* subparagraph*}
      Kramdown::Document.new(@text, params).to_latex
    end

    alias_method :to_html, :convert

    def to_hash_ast
      params = @params.dup
      params[:template] = nil
      Kramdown::Document.new(@text, params).to_hash_ast
    end

    def to_json
      params = @params.dup
      params[:template] = nil
      Kramdown::Document.new(@text, params).to_hash_ast.to_json
    end

    def save_as(filename)
      html = convert
      File.write(filename, html)
    end
  end
end
