class ExpiredSummary

  attr_reader :expired

  def initialize(expired)
    @expired = expired
  end

  def generate
    return if expired.count.zero?
    Slack::Subject.new(title, '', body)
  end

  private

  def title
    "Execution expired on #{expired.count} test#{expired.count == 1 ? '' : 's'}"
  end

  def body
    groups.each { |file_id, exps| "#{file_id} (#{exps.count}x)" }.join("\n")
  end

  def groups
    expired.each_with_object({}) do |exp, memo|
      memo[exp.file_id] ||= []
      memo[exp.file_id] << exp
    end
  end
end
