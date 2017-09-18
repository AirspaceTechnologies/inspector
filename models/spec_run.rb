class SpecRun < ActiveRecord::Base
  has_many :spec_failures, dependent: :destroy
end
