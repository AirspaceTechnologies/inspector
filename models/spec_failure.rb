class SpecFailure < ActiveRecord::Base
  belongs_to :spec_run
  validates :description, :file_path, :spec_run_id, presence: true

  def self.create_from_example!(example, spec_run)
    %w(pending_message status).each{|key| example.delete(key) }        
    create!(example.merge(spec_run_id: spec_run.id))
  end
end
