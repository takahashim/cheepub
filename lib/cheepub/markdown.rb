require 'kramdown'

module Cheepub
  class Markdown
    RUBY_PAT = /{([^}]+)\|([^}]+)}/
    TCY_PAT = /\^([\u0020-\u005d\u005f\u007e]+)\^/ ## \u005e is "^"

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
      @text = do_before_filter(@text)
      Kramdown::Document.new(@text, @params).to_html
    end

    def do_before_filter(text)
      text = ruby_filter(text)
      text = tcy_filter(text)
      text
    end

    def ruby_filter(text)
      text.lines.map do |line|
        line.gsub(RUBY_PAT) do
          "<ruby><rb>#{$1}</rb><rp>（</rp><rt>#{$2}</rt><rp>）</rp></ruby>"
        end
      end.join("")
    end

    def tcy_filter(text)
      text.lines.map do |line|
        line.gsub(TCY_PAT) do
          "<span class=\"tcy\">#{$1}</span>"
        end
      end.join("")
    end

    alias_method :to_html, :convert

    def save_as(filename)
      html = convert
      File.write(filename, html)
    end
  end
end
