class AddStatusToExports < ActiveRecord::Migration[7.1]
  def change
    add_column :exports, :status, :string, default: "new", null: false
  end
end
