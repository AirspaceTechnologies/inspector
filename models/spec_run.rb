class SpecRun < ActiveRecord::Base
  has_many :spec_failures, dependent: :destroy

  scope :unreported, -> { where(reported_at: nil) }
end
