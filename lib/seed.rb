require './lib/bloomed'

ps = [0.01, 0.001, 0.0001]
cs = [1E4, 1E5, 1E6, 1E7, 1E8]

cs.product(ps).each do |c, p|
  b = Bloomed::PW.new(first: c, false_positive_probability: p)
end
