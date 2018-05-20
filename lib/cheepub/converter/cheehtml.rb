require 'open-uri'

module Cheepub
  module Converter
    module CheeHtml

      def initialize(root, options)
        super
        @asset_store = @options[:asset_store]
      end

      def convert_img(el, indent)
        replace_img_path(el)
        super
      end

      def replace_img_path(el)
        src = el.attr['src']
        img_path = @asset_store.store(src, Cheepub::IMAGE_DIR)
        el.attr['src'] = img_path
      end
    end
  end
end

class Kramdown::Converter::Html
  attr_reader :asset_store
  prepend Cheepub::Converter::CheeHtml
end
