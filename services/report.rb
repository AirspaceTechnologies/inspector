class Report
  def close
    SpecRun.unreported.update_all(reported_at: Time.now)
  end

  def write!
    flaky_summary = FlakySummary.new(flakes).generate
    expired_summary = ExpiredSummary.new(expired).generate
    run_summary = RunSummary.new(unreported, failures).generate
    Slack.notify!(flaky_summary.unshift(expired_summary).unshift(run_summary).compact)
  end

  private

  def unreported
    Spec.unreported.to_a
  end

  def failures
    SpecFailure.includes(:spec_run).where(spec_runs: { reported_at: nil })
  end

  def expired
    failures.execution_expired.to_a
  end

  def flakes
    failures.flaky.each_with_object({}) do |failure, memo|
      memo[failure.file_id] ||= []
      memo[failure.file_id] << failure
    end
  end
end
