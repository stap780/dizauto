class AddTestToExport < ActiveRecord::Migration[7.1]
  def change
    add_column :exports, :test, :boolean, default: true
  end
end
