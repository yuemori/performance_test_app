class PerformanceTestFormatter < RSpec::Core::Formatters::DocumentationFormatter
  RSpec::Core::Formatters.register self, :benchmark, :profile, :example_passed

  def initialize(*)
    super
    @benchmarks = []
    @profiles = []
  end

  def benchmark(notification)
    @benchmarks << { benchmark: notification.benchmark, expected_time: notification.expected_time }
  end

  def profile(notification)
    return unless notification.profile

    @profiles << notification.profile
  end

  def example_passed(notification)
    super

    output.write RSpec::Core::Formatters::ConsoleCodes.wrap(format_benchmark, :success)
    dump_profile(notification.example).each_with_index do |path, i|
      output.write RSpec::Core::Formatters::ConsoleCodes.wrap("#{current_indentation}  profile#{i}: #{path}\n", :success)
    end
  ensure
    @benchmarks.clear
    @profiles.clear
  end

  def example_failed(notification)
    super

    output.write RSpec::Core::Formatters::ConsoleCodes.wrap(format_benchmark, :failure)
  ensure
    @benchmarks.clear
    @profiles.clear
  end

  private

  def msec_format(sec)
    (BigDecimal(sec.to_s).floor(3).to_f * 1000).to_i
  end

  def dump_profile(example)
    base = example.full_description.underscore.split.join('-')

    paths = []

    @profiles.each_with_index do |profile, i|
      path = Rails.root.join('tmp', 'profiles', "#{base}-#{i}.dump").to_s

      paths << path

      FileUtils.mkdir_p(File.dirname(path))

      File.open(path, 'wb') do |f|
        f.write Marshal.dump(profile)
      end
    end

    paths
  end

  def format_benchmark
    rows = @benchmarks.map do |benchmark|
      expected = benchmark[:expected_time] ? "#{msec_format(benchmark[:expected_time])} msec" : "none"

      [
        expected,
        "#{msec_format(benchmark[:benchmark][0])} msec",
        "#{msec_format(benchmark[:benchmark][1])} msec",
        "#{msec_format(benchmark[:benchmark][2])} msec",
        "#{msec_format(benchmark[:benchmark][3])} msec"
      ]
    end

    table = Terminal::Table.new(rows: rows, headings: %w[expected user system total real])

    table.to_s.split("\n").map do |line|
      current_indentation + '  ' + line
    end.join("\n") + "\n"
  end
end
