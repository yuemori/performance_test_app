# https://github.com/tmm1/stackprof/blob/master/sample.rb

class A
  def initialize
    pow
    self.class.newobj
  end

  def pow
    2 ** 100
  end

  def self.newobj
    Object.new
    Object.new
  end

  def math
    2.times do
      2 + 3 * 4 ^ 5 / 6
    end
  end
end

StackProf.run(mode: :wall, interval: 1000, out: 'tmp/stackprof.dump') do
  1_000_000.times do
    A.new.math
  end
end
