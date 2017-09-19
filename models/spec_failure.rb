class SpecFailure < ActiveRecord::Base
  belongs_to :spec_run

  validates :description, :file_path, :spec_run_id, presence: true

  scope :execution_expired, -> { where('exception @> ?', { message: 'execution expired' }.to_json) }

  scope :flaky, -> { where.not('exception @> ?', { message: 'execution expired' }.to_json) }

  def self.create_from_example!(example, spec_run)
    %w(pending_message status).each{|key| example.delete(key) }        
    create!(example.merge(spec_run_id: spec_run.id))
  end

  def file_id
    "#{file_path}:#{line_number}"
  end
end
