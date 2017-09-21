class RunSummary

  attr_reader :unreported, :failures

  def initialize(unreported, failures)
    @unreported = unreported
    @failures = failures
  end

  def generate
    Slack::Subject.new(title, '', body)
  end

  private

  def title
    "There were #{unreported.count} spec runs since the last report."
  end

  def body
    success_count = unreported.select{|run| run.success? }.count
    "#{success_count} were successful. #{failures.count} tests failed."
  end
end
