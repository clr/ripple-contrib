module Ripple
  module Contrib
    # Implements the {Riak::Serializer} API for the purpose of
    # encrypting/decrypting Ripple documents.
    #
    # Example usage:
    #     ::Riak::Serializers['application/x-json-encrypted'] = EncryptedSerializer.new
    #     class MyDocument
    #       include Ripple::Document
    #       include Ripple::Contrib::Encryption
    #     end
    #
    # @see Encryption
    class EncryptedSerializer
      # Creates a serializer using the provided cipher and internal
      # content type. Be sure to set the {#key}, {#iv}, {#key_length},
      # {#padding} as appropriate for the cipher before attempting
      # (de-)serialization.
      def initialize
        @config = Ripple::Contrib::Config.new
      end

      # Serializes and encrypts the Ruby object using the assigned
      # cipher and Content-Type.
      # @param [Object] object the Ruby object to serialize/encrypt
      # @return [String] the serialized, encrypted form of the object
      def dump(object)
        JsonDocument.new(@config, object).encrypt
      end

      # Decrypts and deserializes the blob using the assigned cipher
      # and Content-Type.
      # @param [String] blob the original content from Riak
      # @return [Object] the decrypted and deserialized object
      def load(object)
        EncryptedJsonDocument.new(@config, object).decrypt
      end
    end
  end
end
