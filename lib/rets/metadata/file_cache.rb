module Rets
  module Metadata

    # This metadata cache persists the metadata to a file.
    class FileCache

      def initialize(path)
        @path = path
      end

      # Save the metadata.
      def save(metadata)
        File.open(@path, "wb") do |file|
          Marshal.dump(metadata, file)
        end
      end

      # Load the metadata.  Return nil if it could not be loaded.
      def load
        File.open(@path, "rb") do |file|
          Marshal.load(file)
        end
      rescue IOError, SystemCallError
        nil
      end
    end
    
  end
end
