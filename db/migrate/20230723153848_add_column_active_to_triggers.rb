class AddColumnActiveToTriggers < ActiveRecord::Migration[7.0]
  def change
    add_column :triggers, :active, :boolean, default: false
  end
end
