class AddInsaleIdToVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :variants, :insale_id, :integer
  end
end
