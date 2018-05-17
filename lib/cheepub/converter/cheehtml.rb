require 'open-uri'
require 'digest/sha2'

module Cheepub
  module Converter
    module CheeHtml

      def initialize(root, options)
        super
        @img_store = {}
        FileUtils.mkdir_p(@options[:image_dir])
      end

      def convert_img(el, indent)
        replace_img_path(el)
        super
      end

      def replace_img_path(el)
        src = el.attr['src']
        ext = File.extname(src)
        img_content = open(src).read
        img_path = image_filename(img_content, ext)
        if !@img_store[src]
          @img_store[src] = img_path
          File.write(img_path, img_content)
        end
        el.attr['src'] = img_path
      end

      def image_filename(content, ext)
        hash_val = Digest::SHA256.hexdigest(content)
        File.join(@options[:image_dir], hash_val+ext)
      end
    end
  end
end

class Kramdown::Converter::Html
  prepend Cheepub::Converter::CheeHtml
end
