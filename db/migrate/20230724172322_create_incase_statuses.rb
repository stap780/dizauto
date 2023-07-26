class CreateIncaseStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :incase_statuses do |t|
      t.string :title
      t.string :color

      t.timestamps
    end
  end
end
