class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.string :action_name
      t.text :action_params, array: true, default: []
      t.integer :trigger_id

      t.timestamps
    end
  end
end
