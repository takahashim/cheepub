require 'open-uri'

module Cheepub
  module Converter
    module CheeHtml

      def initialize(root, options)
        super
        @image_store = ImageStore.new(@options[:image_dir])
      end

      def convert_img(el, indent)
        replace_img_path(el)
        super
      end

      def replace_img_path(el)
        src = el.attr['src']
        img_path = @image_store.store(src)
        el.attr['src'] = img_path
      end
    end
  end
end

class Kramdown::Converter::Html
  prepend Cheepub::Converter::CheeHtml
end
