require 'msgpack'

module MsgPackable
  module Bloomed
    def self.included(base)
      base.extend(ClassMethods)
    end

    def to_msgpack_ext
      self.class.msgpack_factory.dump([@top, @false_positive_probability, @bloom])
    end

    def from_msgpack_ext(top, false_positive_probability, bloom)
      @top = top
      @false_positive_probability = false_positive_probability
      @bloom = bloom
    end

    def to_msgpack
      self.class.msgpack_factory.dump self
    end

    module ClassMethods
      def from_msgpack(data)
        msgpack_factory.load(data)
      end

      def from_msgpack_ext(data)
        values = msgpack_factory.load(data)
        ::Bloomed::PW.new.tap do |b|
          b.from_msgpack_ext(*values)
        end
      end

      def msgpack_factory
        @msgpack_factory ||= ::MessagePack::Factory.new.tap do |factory|
          factory.register_type(0x01, ::Bloomer)
          factory.register_type(0x02, ::Bloomer::Scalable)
          factory.register_type(0x03, ::Bloomed::PW)
          factory.freeze
        end
      end
    end
  end
end
