module Cheepub
  module ExtHash
    refine Hash do
      def symbolize_keys!
        keys.each do |key|
          if self[key].kind_of? Hash
            self[key].symbolize_keys!
          end
          self[(key.to_sym rescue nil) || key] = delete(key)
        end
        self
      end
    end
  end
end
