require 'securerandom'
require 'gepub'

module Cheepub
  class Generator

    attr_reader :book

    ROLES = %i{aut edt trl ill cov cre pht cwt nrt}

    def initialize(src, params = Hash.new)
      if src.kind_of? Cheepub::Content
        @src = nil
        @content = src
      else
        @src = src
        @content = Cheepub::Content.new(File.read(@src))
      end
      @params = params
      @book = GEPUB::Book.new
    end

    def execute
      params = @params.merge(@content.header)
      check_params(params)
      apply_params(params)
      epubfile = params[:epubfile] || "book.epub"
      @book.generate_epub(epubfile)
    end

    def parse_creator(creator)
      return if !creator
      if creator.kind_of? String
        @book.add_creator(creator)
      else
        creator.each do |role, name|
          if !ROLES.include?(role)
            raise Cheepub::Error, "invalid role: '#{role}' for creator '#{name}'."
          end
          @book.add_creator(name, nil, role)
        end
      end
    end

    def check_params(params)
      if !params[:author] || !params[:title]
        raise Cheepub::Error, "you must use `--author` and `--title`, or add front-matter in Markdown file."
      end
    end

    def apply_params(params)
      @book.identifier = params[:id] || "urn:uuid:#{SecureRandom.uuid}"
      @book.title = params[:title]
      @book.add_creator(params[:author])
      parse_creator(params[:creator])
      @book.language = params[:language] || 'ja'
      @book.version = '3.0'
      @book.publisher = params[:publisher]
      ## book.date= params[:date] || Time.now
      @book.add_date(params[:date] || Time.now, nil)
      @book.lastmodified = params[:lastModified] || Time.now
      @book.page_progression_direction = params[:pageDirection]
      style_content = apply_template("templates/style.css.erb")
      @book.add_item("style.css").add_content(StringIO.new(style_content))
      @book.ordered do
        nav = Cheepub::Nav.new(@content)
        item = @book.add_item('nav.xhtml').add_content(StringIO.new(nav.to_html)).add_property('nav')
        @content.each_html_with_filename do |html, filename|
          @book.add_item(filename).add_content(StringIO.new(html))
        end
      end
    end

    def apply_template(template_file)
      template = File.read(File.join(File.dirname(__FILE__), template_file))
      return ERB.new(template).result(binding)
    end
  end
end
