require 'openssl'
require 'ripple'

module Ripple
  module Contrib
    # When mixed into a Ripple::Document class, this will encrypt the
    # serialized form before it is stored in Riak.  You must register
    # a serializer that will perform the encryption.
    # @see EncryptedSerializer
    module Encryption
      extend ActiveSupport::Concern

      included do
        self.encrypted_content_type = 'application/x-json-encrypted'
        if Ripple::Contrib::Config.new.to_h['encryption'] != false
          self.is_activated = true
          Riak::Serializers['application/x-json-encrypted'] = Ripple::Contrib::EncryptedSerializer.new
        end
      end

      module ClassMethods
        # @return [String] the content type to be used to indicate the
        #     proper encryption scheme.
        attr_accessor :encrypted_content_type
        # @return [Boolean] allow encryption to be turned off in the config file
        attr_accessor :is_activated
      end

      # Overrides the internal method to set the content-type to be
      # encrypted.
      def update_robject
        super
        if self.class.is_activated
          robject.content_type = self.class.encrypted_content_type
        end
      end
    end
  end
end
