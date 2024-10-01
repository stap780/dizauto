class AddIndexToImagesProductId < ActiveRecord::Migration[7.1]
  def change
    add_index :images, :product_id
  end
end
