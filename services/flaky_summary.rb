class FlakySummary

  attr_reader :flakes

  def initialize(flakes)
    @flakes = flakes
  end

  def generate
    flakes.map do |file_id, failures|
      Slack::Subject.new(title(file_id, failures), link(failures.first), body(failures.first))
    end
  end

  private

  def title(file_id, failures)
    "#{file_id} failed #{failures.size} time#{failures.size == 1 ? '' : 's'}"
  end

  def link(failure)
    full_path = failure.file_path
    relative_path = full_path[full_path.index('spec')..-1]
    "https://github.com/AirspaceTechnologies/PackageTracker/blob/dev/#{relative_path}#L#{failure.line_number}"
  end

  def body(failure)
    backtrace = failure.exception['backtrace']&.find { |trace| trace.include?('PackageTracker') }
    [ failure.exception['message'], format_backtrace(backtrace) ].join("\n")
  end

  def format_backtrace(trace)
    return '' unless trace
    ndx = trace.index('PackageTracker')
    trace[(trace.index('/', ndx) + 1)..-1]
  end
end
