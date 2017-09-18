class CreateSpecFailures < ActiveRecord::Migration[5.0]  
  def change
    create_table :spec_failures do |t|
      t.references :spec_run
      t.string :description, null: false
      t.string :full_description
      t.string :file_path, null: false
      t.integer :line_number
      t.decimal :run_time 
      t.jsonb :exception      
      t.timestamps      
    end
  end
end