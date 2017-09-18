class CreateSpecRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :spec_runs do |t|      
      t.datetime :reported_at
      t.timestamps      
    end
  end
end