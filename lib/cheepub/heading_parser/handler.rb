module Cheepub
  class HeadingParser
    class Handler

      attr_reader :result

      def initialize(filename)
        @filename = filename
        @stack = []
        @result = []
      end

      def on_element(ns, name, attrs)
        if name =~ /^h([1-6])/i
          @stack.push({filename: @filename, name: name, level: $1.to_i, content: "", id: attrs["id"]})
        end
      end

      def on_text(text)
        last_elem = @stack[-1]
        return if !last_elem
        last_elem[:content] = last_elem[:content]+text
      end

      def after_element(ns, name)
        return if @stack.empty?
        @result.push(@stack.pop)
      end
    end
  end
end
