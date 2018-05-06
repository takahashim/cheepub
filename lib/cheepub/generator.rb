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
      epubname = params[:epubname] || "book.epub"
      book.generate_epub(epubname)
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
        raise Cheepub::Error, "author and title should be defined."
      end
    end

    def apply_params(book, params)
      book.identifier = params[:id] || "urn:uuid:#{SecureRandom.uuid}"
      book.title = params[:title]
      if params[:creator]
        parse_creator(book, params[:creator])
      end
      book.add_creator(params[:author])
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
        @content.html_pages.each_with_index do |page, idx|
          item = book.add_item("bodymatter_0_#{idx}.xhtml")
          item.add_content(StringIO.new(page))
        end
      end
    end
  end
end
