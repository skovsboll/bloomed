require 'bloomed/version'
require 'bloomer'

module Bloomed
  class PW
    attr_reader :false_positive_probability

    def initialize(false_positive_probability: 0.001) # 0.1%
      @false_positive_probability = false_positive_probability
      @bloom = prepare
    end

    def lookup(pw)
      @bloom.include? pw
    end

    private

    def prepare
      if File.exist? file_name
        load_cache
      else
        write_cache
      end
    end

    def file_name
      "bloom_#{false_positive_probability}.dump"
    end

    def load_cache
      Marshal.load(File.read(file_name))
    end

    def write_cache
      b = Bloomer::Scalable.new(false_positive_probability)

      File.open("pwned-passwords-ordered-by-hash.7z", "rb") do |file|
        SevenZipRuby::Reader.open(file) do |szr|
          print szr.entries
          # smallest_file = szr.entries.select(&:file?).min_by(&:size)
          # data = szr.extract_data(smallest_file)
        end
      end

      File.write(file_name, Marshal.dump(b))
      b
    end
  end
end
