require 'stackprof'

RSpec::Matchers.define :benchmark do
  match do |given_proc|
    @given_proc = given_proc
    @benchmark = []

    warmup(given_proc)

    @benchmark = benchmark(given_proc)

    profile(given_proc) if @with_profile

    return true unless @expected_time

    @expected_time > @benchmark.last
  end

  def supports_block_expectations?
    true
  end

  failure_message do |actual|
    "#{@actual} is slower than #{msec_format(@expected_time)} msec"
  end

  chain :earlier_than do |value|
    @expected_time = value
  end

  chain :with_profile do
    @with_profile = true
  end

  private

  def profile(block)
    StackProf.start(mode: :wall, raw: true, interval: 100)
    block.call
    StackProf.stop

    RSpec.configuration.reporter.publish(
      :profile,
      profile: StackProf.results
    )
  end

  def benchmark(block)
    benchmarks = []
    benchmark_times = @benchmark_times || 30

    benchmark_times.times do
      result = with_gc_stats do
        Benchmark.measure do
          block.call
        end
      end

      benchmarks << [result.utime, result.stime, result.total, result.real]
    end

    utime = benchmarks.sum { |v| v[0] } / benchmark_times
    stime = benchmarks.sum { |v| v[1] } / benchmark_times
    total = benchmarks.sum { |v| v[2] } / benchmark_times
    real = benchmarks.sum { |v| v[3] } / benchmark_times

    benchmark = [utime, stime, total, real]

    RSpec.configuration.reporter.publish(
      :benchmark,
      benchmark: benchmark,
      expected_time: @expected_time
    )

    benchmark
  end

  def warmup(block)
    3.times do
      block.call
    end
  end

  def msec_format(sec)
    (BigDecimal(sec.to_s).floor(3).to_f * 1000).to_i
  end

  def with_gc_stats
    GC::Profiler.enable
    GC.start
    result = yield
  ensure
    GC::Profiler.disable
    result
  end
end
