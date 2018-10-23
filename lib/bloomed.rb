require_relative "bloomed/version"
require_relative "bloomed/msg_packable"
require "bloomer"
require "bloomer/msgpackable"

require_relative 'railtie' if defined?(Rails)

module Bloomed
  class PW
    include MsgPackable::Bloomed

    attr_reader :false_positive_probability,
                :top,
                :bloom,
                :cache_dir,
                :filename

    def initialize(top: 100_000,
                   false_positive_probability: 0.001,
                   cache_dir: nil)
      @cache_dir = cache_dir || File.join(File.dirname(__FILE__), "dump")
      @top = top
      @false_positive_probability = false_positive_probability
      @bloom = prepare
    end

    def pwned?(pw)
      @bloom.include?(Digest::SHA1.hexdigest(pw).upcase)
    end

    def memory_size_bytes
      require "objspace"
      ObjectSpace.memsize_of(@bloom)
    end

    def filename
      inverse_probaility = 1.0 / false_positive_probability
      File.join(cache_dir,
                "pwned_top_#{top.to_i}_one_in_#{inverse_probaility.round}.msgpk")
    end

    private

    def prepare
      if File.exist? filename
        load_cache
      else
        bloom_filter = generate
        write_cache bloom_filter
        bloom_filter
      end
    end

    def load_cache
      Bloomed::PW.from_msgpack(File.read(filename))
    end

    PWNED_PASSWORDS_FILENAME = "pwned-passwords-ordered-by-count.txt".freeze

    def generate
      unless File.exist? PWNED_PASSWORDS_FILENAME
        raise MissingPasswordListError, "To generate new, optimized pwned passwords bloom filter, run `rake seed` or `rake seed_here`. To generate all variants, even the very large binaries, run `rake seed\[all\]` or `rake seed_here\[all\]`."
      end

      bloom_filter = Bloomer.new(top, false_positive_probability)
      File.open(PWNED_PASSWORDS_FILENAME, "r").first(top).each do |line|
        bloom_filter.add line[0...40]
      end
      bloom_filter
    end

    def write_cache(b)
      File.open(filename, 'wb') { |f| f.write b.to_msgpack }
      b
    end
  end

  class MissingPasswordListError < RuntimeError
  end
end
