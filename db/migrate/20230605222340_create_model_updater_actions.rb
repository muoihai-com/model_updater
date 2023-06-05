class CreateModelUpdaterActions < ActiveRecord::Migration[6.1]
  def change
    create_table :model_updater_actions do |t|
      t.string :name
      t.text :up
      t.text :down
      t.integer :execution_type

      t.timestamps
    end
  end
end
