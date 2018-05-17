require 'digest/sha2'
require 'base64'

module Cheepub
  class ImageStore
    def initialize(image_dir)
      @store = {}
      @image_dir = image_dir
      FileUtils.mkdir_p(@image_dir)
    end

    def store(src)
      ext = File.extname(src)
      img_content = open(src){|f| f.read}
      img_path = image_filename(img_content, ext)
      if !@store[src]
        @store[src] = img_path
        File.write(img_path, img_content)
      end
      img_path
    end

    def image_filename(content, ext)
      hash_val = Digest::SHA256.digest(content)
      basename = Base64.urlsafe_encode64(hash_val)
      File.join(@image_dir, "#{basename}#{ext}")
    end

    def [](key)
      @store[key]
    end

    def []=(key,val)
      @store[key] = val
    end
  end
end
