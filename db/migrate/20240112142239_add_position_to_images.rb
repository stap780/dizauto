class AddPositionToImages < ActiveRecord::Migration[7.1]
  def up
    add_column :images, :position, :integer, null: false, default: 1
    execute <<~SQL.squish
      alter table images add constraint unique_product_id_position unique (product_id, position) deferrable initially deferred;
    SQL
  end

  def down
    execute <<~SQL.squish
      alter table images drop constraint unique_product_id_position
    SQL
    remove_column :images, :position, :integer, null: false, default: 1
  end
end
