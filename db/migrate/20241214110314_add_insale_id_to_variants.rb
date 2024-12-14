class AddInsaleIdToVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :variants, :insid, :integer
  end
end
