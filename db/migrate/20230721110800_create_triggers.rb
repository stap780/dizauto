class CreateTriggers < ActiveRecord::Migration[7.0]
  def change
    create_table :triggers do |t|
      t.string :title
      t.string :event
      t.string :condition
      t.string :action
      t.integer :template_id
      t.boolean :pause
      t.string :pause_time

      t.timestamps
    end
  end
end
