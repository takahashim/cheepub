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
        outfile = params[:outfile] || "book.pdf"
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
        @maker.date= params[:date] || Time.now
        @maker.lastmodified = params[:lastModified] || Time.now
        @maker.page_progression_direction = params[:pageDirection]
        @content.each_content_with_filename("tex") do |content, filename|
          @maker.add_item(filename, content)
        end
      end

      def apply_template(template_file)
        template = File.read(File.join(Cheepub::Generator::TEMPLATES_DIR, template_file))
        return ERB.new(template).result(binding)
      end
    end
  end
end
