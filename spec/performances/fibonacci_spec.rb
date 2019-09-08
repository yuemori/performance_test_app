require 'rails_helper'

describe 'Performance:Fibonacci', type: :feature do
  def visit_page(fibonacci)
    visit fibonacci_path(id: fibonacci.id)
  end

  let!(:fibonacci) { FactoryBot.create :fibonacci, number: 10 }

  it { expect { visit_page(fibonacci) }.to benchmark.with_profile }

  context 'when number is small' do
    let!(:fibonacci) { FactoryBot.create :fibonacci, number: 20 }

    it { expect { visit_page(fibonacci) }.to benchmark.earlier_than(0.1) }
  end

  context 'when number is large' do
    let!(:fibonacci1) { FactoryBot.create :fibonacci, number: 30 }
    let!(:fibonacci2) { FactoryBot.create :fibonacci, number: 30 }

    it do
      expect { visit_page(fibonacci1) }.to benchmark.earlier_than(0.1)
      expect { visit_page(fibonacci2) }.to benchmark.earlier_than(0.15)
    end
  end
end
