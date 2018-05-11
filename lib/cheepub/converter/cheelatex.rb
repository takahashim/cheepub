require "kramdown/converter/latex"

module Cheepub
  module Converter
    module CheeLatex

      def convert_p(el, opts)
        if el.children.size == 1 && el.children.first.type == :img && !(img = convert_img(el.children.first, opts)).empty?
          convert_standalone_image(el, opts, img)
        elsif el.attr['class'].to_s =~ /text\-right/
          "#{latex_link_target(el)}\\begin{flushright}#{inner(el, opts)}\\end{flushright}\n\n"
        else
          "#{latex_link_target(el)}#{inner(el, opts)}\n\n"
        end
      end

      def convert_codeblock(el, opts)
        show_whitespace = el.attr['class'].to_s =~ /\bshow-whitespaces\b/
        lang = extract_code_language(el.attr)

        if @options[:syntax_highlighter] == :minted &&
            (highlighted_code = highlight_code(el.value, lang, :block))
          @data[:packages] << 'minted'
          "#{latex_link_target(el)}#{highlighted_code}\n"
        elsif (show_whitespace || lang) && @options[:syntax_highlighter]
          options = []
          options << "showspaces=%s,showtabs=%s" % (show_whitespace ? ['true', 'true'] : ['false', 'false'])
          options << "language=#{lang}" if lang
          options << "basicstyle=\\ttfamily\\footnotesize,columns=fixed,frame=tlbr"
          id = el.attr['id']
          options << "label=#{id}" if id
          attrs = attribute_list(el)
          "#{latex_link_target(el)}\\begin{lstlisting}[#{options.join(',')}]\n#{el.value}\n\\end{lstlisting}#{attrs}\n"
        else
          "#{latex_link_target(el)}\\begin{verbatim}#{el.value}\\end{verbatim}\n"
        end
      end

      def convert_html_element(el, opts)
        case el.value
        when :ruby
          str = inner(el, opts)
          "\\ruby[g]{#{str}}"
        when :rt
          str = inner(el, opts)
          "}{#{str}"
        when :span
          "\\rensuji{#{inner(el, opts)}}"
        when "p"
          if el.children.size == 1 && el.children.first.value == "br"
            "\\rblatexEmptyLine\n"
          else
            super
          end
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
