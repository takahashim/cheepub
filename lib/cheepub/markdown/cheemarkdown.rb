require 'kramdown/parser/kramdown'

module Kramdown
  module Parser
    class CheeMarkdown < Kramdown::Parser::GFM

      def initialize(source, options)
        super
        @span_parsers.unshift(:ruby)
        @block_parsers.delete(:table)
      end

      RUBY_START = /(?:\{)           ## begin
                    ([^:\|}][^\|}]*) ## base text
                    \|               ## separator
                    ([^\|}]+)        ## ruby text
                    (?:\})/x         ## end

      def parse_ruby
        start_line_number = @src.current_line_number
        @src.pos += @src.matched_size
        ruby_base, ruby_text = @src[1], @src[2]
        ruby_el = Element.new(:html_element, :ruby, nil, :category => :span, :localtion => start_line_number)
        @tree.children << ruby_el

        @stack.push([@tree, @text_type])
        @tree = ruby_el
        add_text(ruby_base)

        ruby_text_el = Element.new(:html_element, :rt, nil, :category => :span, :localtion => start_line_number)
        @tree.children << ruby_text_el

        @stack.push([@tree, @text_type])

        @tree = ruby_text_el
        add_text(ruby_text)

        @tree, @text_type = @stack.pop
        @tree, @text_type = @stack.pop
      end

      define_parser(:ruby, RUBY_START, '\{[^:]')
    end
  end
end
