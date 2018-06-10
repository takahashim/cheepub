require 'cheepub/generator'
require 'rb_latex'

module Cheepub
  class Generator
    class Latex < Cheepub::Generator

      attr_reader :maker

      def initialize(src, params = Hash.new)
        super
        root_dir = File.dirname(src)
        @maker = RbLatex::Maker.new(root_dir)
      end

      def output_file(params)
        outfile = params[:output] || "book.pdf"
        @maker.generate_pdf(outfile, debug: params[:debug])
      end

      def add_creator(name, role = "aut")
        @maker.add_creator(name, role)
      end

      def apply_params(params)
        @maker.title = params[:title]
        add_creator(params[:author])
        parse_creator(params[:creator])
        ##@maker.language = params[:language] || 'ja'
        @maker.publisher = params[:publisher] if params[:publisher]
        @maker.date = params[:date] || Time.now
        @maker.lastmodified = params[:lastModified] || Time.now
        @maker.page_progression_direction = params[:pageDirection]
        if params.key?(:latexCommand)
          @maker.latex_command = params[:latexCommand]
        end
        if params.key?(:dvipdfCommand)
          @maker.dvipdf_command = params[:dvipdfCommand]
        end
        @maker.debug = params[:debug]
        if params[:documentClass]
          @maker.document_class = params[:documentClass]
        end
        if params[:titlepage]
          @maker.titlepage = params[:titlepage]
        end
        if params[:colophon]
          @maker.colophon = params[:colophon]
        end
        if params[:colophon_before]
          @maker.colophon_before = params[:colophon_before].gsub(/\n/m, "\\par ") + "\\vspace{5mm} \\par\n"
        end
        if params[:colophon_after]
          @maker.colophon_after = params[:colophon_after].gsub(/\n/m, "\\par ")
        end
        @content.each_with_index do |file, idx|
          content = Cheepub::Markdown.new(file, page_direction: params[:pageDirection]).to_latex
          filename = "bodymatter_#{idx}.tex"
          @maker.add_item(filename, content)
        end
      end

      def apply_template(template_file)
        template = File.read(File.join(Cheepub::TEMPLATES_DIR, template_file))
        return ERB.new(template).result(binding)
      end
    end
  end
end
