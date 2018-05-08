require "kramdown/converter/latex"

module Cheepub
  module Converter
    module CheeLatex
      def convert_html_element(el, opts)
        if el.value == :ruby
          str = inner(el, opts)
          "\\ruby[g]{#{str}}"
        elsif el.value == :rt
          str = inner(el, opts)
          "}{#{str}"
        elsif el.value == :span
          "\\rensuji{#{inner(el, opts)}}"
        else
          super
        end
      end
    end
  end
end

class Kramdown::Converter::Latex
  prepend Cheepub::Converter::CheeLatex
end
