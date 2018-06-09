module Cheepub
  module ExtHash
    refine Hash do
      def symbolize_keys!
        keys.each do |key|
          if self[key].kind_of? Hash
            self[key].symbolize_keys!
          end
          self[key_to_sym(key)] = delete(key)
        end
        self
      end

      def key_to_sym(key)
        (key.to_sym rescue nil) || key
      end

      def deep_merge!(other_hash, &block)
        merge!(other_hash) do |key, this_val, other_val|
          if this_val.is_a?(Hash) && other_val.is_a?(Hash)
            this_val.dup.deep_merge!(other_val, &block)
          elsif block_given?
            block.call(key, this_val, other_val)
          else
            other_val
          end
        end
      end
    end
  end
end
