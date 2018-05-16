require 'securerandom'
require 'gepub'
require 'cheepub/generator'

module Cheepub
  class Generator
    class Epub < Cheepub::Generator

      attr_reader :book

      def initialize(src, params = Hash.new)
        super
        @book = GEPUB::Book.new
      end

      def output_file(params)
        output = params[:output] || "book.epub"
        @book.generate_epub(output)
      end

      def add_creator(name, role)
        @book.add_creator(name, nil, role)
      end

      def apply_params(params)
        @book.identifier = params[:id] || "urn:uuid:#{SecureRandom.uuid}"
        @book.title = params[:title]
        @book.add_creator(params[:author])
        parse_creator(params[:creator])
        @book.language = params[:language] || 'ja'
        @book.version = '3.0'
        @book.publisher = params[:publisher] if params[:publisher]
        ## book.date= params[:date] || Time.now
        @book.add_date(params[:date] || Time.now, nil)
        @book.lastmodified = params[:lastModified] || Time.now
        @book.page_progression_direction = params[:pageDirection]
        style_content = apply_template("style.css.erb")
        @book.add_item("style.css").add_raw_content(style_content)
        @book.ordered do
          make_titlepage(params)
          nav = Cheepub::Nav.new(@content)
          @book.add_item('nav.xhtml', nil,nil,'properties'=>['nav']).add_raw_content(nav.to_html)
          @content.each_content_with_filename("xhtml") do |html, filename|
            @book.add_item(filename).add_raw_content(html)
          end
        end
      end

      def make_titlepage(params)
        if params[:titlepage]
          titlepage_content = apply_template("titlepage.xhtml.erb")
          @book.add_item("titlepage.xhtml").add_raw_content(titlepage_content)
        end
      end

      def apply_template(template_file)
        template = File.read(File.join(Cheepub::TEMPLATES_DIR, template_file))
        return ERB.new(template).result(binding)
      end
    end
  end
end
