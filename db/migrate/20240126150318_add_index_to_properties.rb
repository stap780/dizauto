class AddIndexToProperties < ActiveRecord::Migration[7.1]
  def change
    add_index :properties, :title
  end
end
