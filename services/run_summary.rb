class RunSummary

  attr_reader :unreported, :failures

  def initialize(unreported, failures)
    @unreported = unreported
    @failures = failures
  end

  def generate
    Slack::Subject.new(title, '', '')
  end

  private

  def title
    """
      There have been #{unreported.count} spec runs since the last report.
      #{unreported.select{|run| run.success? }.count} were successful.
      The others accumulated #{failures.count} failed tests.
    """
  end
end
