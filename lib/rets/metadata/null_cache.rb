module Rets
  module Metadata

    # This type of metadata cache, which is the default, neither saves
    # nor restores.
    class NullCache

      # Save the metadata.
      def save(metadata)
      end

      # Load the metadata.  Return nil if it could not be loaded.
      def load
        nil
      end
      
    end
    
  end
end
