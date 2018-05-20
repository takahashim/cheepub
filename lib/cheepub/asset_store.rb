require 'digest/sha2'
require 'base64'
require 'fileutils'
require 'tmpdir'

module Cheepub
  class AssetStore
    def initialize(asset_dir)
      @store = {}
      @asset_dir = asset_dir
    end

    def store(src)
      ext = File.extname(src)
      img_content = open(src){|f| f.read}
      img_path = asset_filename(img_content, ext)
      if !@store[src]
        @store[src] = img_path
        File.write(img_path, img_content)
      end
      img_path
    end

    def clear
      FileUtils.remove_entry_secure(@asset_dir)
    end

    def [](key)
      @store[key]
    end

    def []=(key,val)
      @store[key] = val
    end

    def asset_filename(content, ext)
      hash_val = Digest::SHA256.digest(content)
      basename = Base64.urlsafe_encode64(hash_val)
      File.join(@asset_dir, "#{basename}#{ext}")
    end
  end
end
