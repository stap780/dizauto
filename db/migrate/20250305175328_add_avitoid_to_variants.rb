class AddAvitoidToVariants < ActiveRecord::Migration[7.1]
  def change
    add_column :variants, :avitoid, :integer
  end
end
