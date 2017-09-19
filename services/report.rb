class Report
  def close
    SpecRun.where(reported_at: nil).update_all(reported_at: Time.now)
  end

  def write!
    Slack.notify!(flaky_summary.unshift(expired_summary).unshift(run_summary))
  end

  private

  def failures
    SpecFailure.includes(:spec_run).where(spec_runs: { reported_at: nil })
  end

  def flakes
    failures.flaky.each_with_object({}) do |failure, memo|
      memo[failure.file_id] ||= []
      memo[failure.file_id] << failure
    end
  end

  def expired
    @expired ||= failures.execution_expired.to_a
  end

  def run_summary
    Slack::Subject.new(
      "There have been #{failures.pluck(:spec_run_id).uniq.count} spec runs since the last report",
      '',
      ''
    )
  end

  def expired_summary
    Slack::Subject.new(
      "Execution expired on #{expired.count} specs",
      '',
      expired.map(&:file_id).uniq.join("\n")
    )
  end

  def flaky_summary
    flakes.map do |file_id, failures|
      Slack::Subject.new(
        "#{file_id} failed #{failures.size} times",
        github_link_for(failures.first),
        error_info_for(failures.first)
      )
    end
  end

  def github_link_for(failure)
    full_path = failure.file_path
    relative_path = full_path[full_path.index('spec')..-1]
    "https://github.com/AirspaceTechnologies/PackageTracker/blob/dev/#{relative_path}#L#{failure.line_number}"
  end

  def error_info_for(failure)
    backtrace = failure.exception['backtrace']&.find { |trace| trace.include?('PackageTracker') }
    [ failure.exception['message'], format_backtrace(backtrace) ].join("\n")
  end

  def format_backtrace(trace)
    return '' unless trace
    ndx = trace.index('PackageTracker')
    trace[(trace.index('/', ndx) + 1)..-1]
  end
end
