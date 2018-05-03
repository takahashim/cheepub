module Cheepub
  module ExtHash
    refine Hash do
      def symbolize_keys!
        keys.each do |key|
          self[(key.to_sym rescue nil) || key] = delete(key)
        end
        self
      end
    end
  end
end
