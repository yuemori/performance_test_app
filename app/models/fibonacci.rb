class Fibonacci < ApplicationRecord
  def result
    calculate(number)
  end

  private

  def calculate(n)
    return   if n < 0
    return n if n < 2

    calculate(n - 1) + calculate(n - 2)
  end
end
