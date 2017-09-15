class CreateSpecFailures < ActiveRecord::Migration[5.0]
  # migrate with CreateExamples.migrate(:up)
  def change
    create_table :spec_failures do |t|
      t.string :description, null: false
      t.string :full_description
      t.string :file_path, null: false
      t.integer :line_number
      t.decimal :run_time 
      t.jsonb :exception
      t.integer :sightings, default: 1, index: true
      t.datetime :last_seen, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
      t.index %i(description file_path), unique: true
    end
  end
end