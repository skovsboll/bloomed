require "bloomed"

KB = 2 ** 10

module Seeder

  def self.seed(all: false, cache_dir: nil)
    ps = [0.01, 0.001, 0.0001, 0.00001]
    cs = [1E4, 1E5]

    if all
      cs += [1E6, 1E7, 1E8]
    end

    cs.product(ps).each do |c, p|
      print "Generating filter for top #{c.to_i} with #{p} precision "
      b = Bloomed::PW.new(top: c, false_positive_probability: p, cache_dir: cache_dir)
      size = File.size(b.filename)
      puts "Done [#{size / KB} kb]"
    end
  end
end
