class Fibonacci < ApplicationRecord
  def result
    calculate(number)
  end

  private

  def calculate(n)
    return   if n < 0
    return n if n < 2

    a = 0
    b = 1

    n.times { a, b = b, a + b }

    a
  end
end
