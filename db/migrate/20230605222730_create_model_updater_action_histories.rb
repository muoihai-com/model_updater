class CreateModelUpdaterActionHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :model_updater_action_histories do |t|
      t.string :executer
      t.integer :action_id
      t.boolean :validation_error_flag

      t.timestamps
    end
  end
end
