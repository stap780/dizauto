class AddIndexToCharacteristics < ActiveRecord::Migration[7.1]
  def change
    add_index :characteristics, :title
  end
end
