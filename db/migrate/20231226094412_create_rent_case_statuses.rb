class CreateRentCaseStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :rent_case_statuses do |t|
      t.string :title
      t.string :color
      t.integer :position, null: false, default: 1

      t.timestamps
    end
  end
end
