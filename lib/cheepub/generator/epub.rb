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
        @asset_store = AssetStore.new(Dir.mktmpdir("cheepub"), @src ? File.dirname(@src) : nil)
        params[:asset_store] = @asset_store
      end

      def output_file(params)
        output = params[:output] || "book.epub"
        @book.generate_epub(output)
      end

      def add_creator(name, role)
        @book.add_creator(name, nil, role: role)
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
        @book.page_progression_direction = params[:pageDirection] || "ltr"
        style_content = apply_template("style.css.erb")
        @book.add_item("style.css").add_raw_content(style_content)
        @book.ordered do
          make_titlepage(params)
          nav = Cheepub::Nav.new(@content)
          @book.add_item('nav.xhtml', nil,nil,'properties'=>['nav']).add_raw_content(nav.to_html)
          @content.each_with_index do |file, idx|
            html = Cheepub::Markdown.new(file, asset_store: @asset_store).to_html
            filename = "bodymatter_#{idx}.xhtml"
            @book.add_item(filename).add_raw_content(html)
          end
          make_colophon(params)
        end
        @asset_store.each_relpath_and_content do |path, content|
          @book.add_item(path).add_raw_content(content)
        end
      end

      def make_titlepage(params)
        if params[:titlepage]
          titlepage_content = apply_template("titlepage.xhtml.erb")
          @book.add_item("titlepage.xhtml").add_raw_content(titlepage_content)
        end
      end

      def make_colophon(params)
        if params[:colophon]
          @colophon = params[:colophon]
          @colophon_before = params[:colophon_before] || ""
          @colophon_after = params[:colophon_after] || ""
          content = apply_template("colophon.xhtml.erb")
          @book.add_item("colophon.xhtml").add_raw_content(content)
        end
      end

      def apply_template(template_file)
        template = File.read(File.join(Cheepub::TEMPLATES_DIR, template_file))
        return ERB.new(template).result(binding)
      end
    end
  end
end
