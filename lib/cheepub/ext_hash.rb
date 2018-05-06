module Cheepub
  module ExtHash
    refine Hash do
      def symbolize_keys!
        keys.each do |key|
          if self[key].kind_of? Hash
            self[key].symbolize_keys!
          end
          self[symbolize_key(key)] = delete(key)
        end
        self
      end

      def symbolize_key(key)
        (key.to_sym rescue nil) || key
      end
    end
  end
end
