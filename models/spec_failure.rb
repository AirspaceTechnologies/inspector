class SpecFailure < ActiveRecord::Base
  validates :description, :file_path, presence: true

  def self.save_from_example(attributes = {})
    %w(pending_message status).each{|key| attributes.delete(key) }        
    record_from(attributes).spot!(attributes)        
  end

  def self.record_from(attributes)
    find_or_initialize_by(description: attributes['description'], file_path: attributes['file_path'])
  end

  def spot!(attributes)
    update!(
      attributes.merge(
        sightings: sightings + (new_record? ? 0 : 1),
        last_seen: Time.now
      )    
    )
  end

  def to_s
    """      
      #{file_path}:#{line_number}
      \"#{description}\"
      Has failed #{sightings} times
    """
  end
end
