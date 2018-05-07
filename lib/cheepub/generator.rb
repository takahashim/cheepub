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
      params = @content.header.merge(@params){|key, val, arg_val| arg_val.nil? ? val : arg_val}
      check_params(params)
      apply_params(params)
      epubfile = params[:epubfile] || "book.epub"
      @book.generate_epub(epubfile)
    end

    def parse_creator(creator)
      case creator
      when nil
        return
      when String
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
      @book.add_item("style.css").add_raw_content(style_content)
      @book.ordered do
        make_titlepage(params)
        nav = Cheepub::Nav.new(@content)
        @book.add_item('nav.xhtml', nil,nil,'properties'=>['nav']).add_raw_content(nav.to_html)
        @content.each_html_with_filename do |html, filename|
          @book.add_item(filename).add_raw_content(html)
        end
      end
    end

    def apply_template(template_file)
      template = File.read(File.join(File.dirname(__FILE__), template_file))
      return ERB.new(template).result(binding)
    end

    def make_titlepage(params)
      if params[:titlepage]
        titlepage_content = apply_template("templates/titlepage.xhtml.erb")
        @book.add_item("titlepage.xhtml").add_raw_content(titlepage_content)
      end
    end
  end
end
