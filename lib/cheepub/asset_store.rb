require 'digest/sha2'
require 'base64'
require 'fileutils'
require 'tmpdir'
require 'pathname'

module Cheepub
  class AssetStore
    def initialize(asset_dir)
      @store = {}
      @asset_dir = Pathname.new(asset_dir)
    end

    def store(src, dir)
      ext = File.extname(src)
      img_content = open(src){|f| f.read}
      img_path = asset_file_path(img_content, dir, ext)
      if !@store[src]
        @store[src] = img_path
        FileUtils.mkdir_p(img_path.dirname.to_s)
        File.write(img_path.to_s, img_content)
      end
      img_path.relative_path_from(@asset_dir)
    end

    def clear
      FileUtils.remove_entry_secure(@asset_dir.to_s)
    end

    def [](key)
      @store[key]
    end

    def []=(key,val)
      @store[key] = val
    end

    def asset_file_path(content, dir, ext)
      hash_val = Digest::SHA256.digest(content)
      basename = Base64.urlsafe_encode64(hash_val)
      path = @asset_dir + dir + "#{basename}#{ext}"
      path
    end
  end
end
