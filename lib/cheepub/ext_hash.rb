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
    end
  end
end
