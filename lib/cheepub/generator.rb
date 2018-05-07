require 'securerandom'
require 'gepub'

module Cheepub
  class Generator

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
    end

    def execute
      params = @params.merge(@content.header)
      check_params(params)
      book = GEPUB::Book.new
      apply_params(book, params)
      epubfile = params[:epubfile] || "book.epub"
      book.generate_epub(epubfile)
    end

    def parse_creator(book, creator)
      if creator.kind_of? String
        book.add_creator(creator)
      else
        creator.each do |role, name|
          if !ROLES.include?(role)
            raise Cheepub::Error, "invalid role: '#{role}' for creator '#{name}'."
          end
          book.add_creator(name, nil, role)
        end
      end
    end

    def check_params(params)
      if !params[:author] || !params[:title]
        raise Cheepub::Error, "you must use `--author` and `--title`, or add front-matter in Markdown file."
      end
    end

    def apply_params(book, params)
      book.identifier = params[:id] || "urn:uuid:#{SecureRandom.uuid}"
      book.title = params[:title]
      book.add_creator(params[:author])
      if params[:creator]
        parse_creator(book, params[:creator])
      end
      book.language = params[:language] || 'ja'
      book.version = '3.0'
      book.publisher = params[:publisher]
      ## book.date= params[:date] || Time.now
      book.add_date(params[:date] || Time.now, nil)
      book.lastmodified = params[:lastModified] || Time.now
      if params[:pageDirection]
        book.page_progression_direction = params[:pageDirection]
      end
      File.open(File.join(File.dirname(__FILE__), "templates/style.css.erb")) do |f|
        item = book.add_item("style.css")
        item.add_content(f)
      end
      book.ordered do
        nav = Cheepub::Nav.new(@content)
        root = nav.parse_content
        item = book.add_item('nav.xhtml')
        item.add_content(StringIO.new(nav.to_html))
        item.add_property('nav')
        @content.each_html_with_filename do |html, filename|
          item = book.add_item(filename)
          item.add_content(StringIO.new(html))
        end
      end
    end
  end
end
