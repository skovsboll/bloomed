# require 'bloomed/version'
require 'bloomer'

module Bloomed
  class PW
    attr_reader :false_positive_probability, :first

    def initialize(first: 100_000, false_positive_probability: 0.001)
      @first = first
      @false_positive_probability = false_positive_probability
      @bloom = prepare
    end

    def pwned?(pw)
      @bloom.include?(Digest::SHA1.hexdigest(pw).upcase)
    end

    def memory_size_bytes
      require 'objspace'
      ObjectSpace.memsize_of(@bloom)
    end

    private

    def prepare
      if File.exist? file_name
        load_cache
      else
        bloom_filter = generate
        write_cache(bloom_filter)
        bloom_filter
      end
    end

    def file_name
      inverse_probaility = 1.0 / false_positive_probability
      "pwned_top_#{first.to_i}_one_in_#{inverse_probaility.to_i}.dump"
    end

    def load_cache
      Marshal.load(File.read(file_name))
    end

    PWNED_PASSWORDS_FILENAME = 'pwned-passwords-ordered-by-count.txt'
    def generate
      
      fail "In order to generate new, optimized bloom filter for 
      pwned passwords, please download pwned-passwords-ordered-by-count.7z from
      https://haveibeenpwned.com and extract pwned-passwords-ordered-by-count.txt
      to the current dir." unless File.exist? PWNED_PASSWORDS_FILENAME

      bloom_filter = Bloomer::Scalable.new(first, false_positive_probability)
      File.open(PWNED_PASSWORDS_FILENAME, 'r').first(first).each do |line|
        bloom_filter.add line[0...40]
      end
      bloom_filter
    end

    def write_cache(b)
      File.write(file_name, Marshal.dump(b))
      b
    end
  end
end
