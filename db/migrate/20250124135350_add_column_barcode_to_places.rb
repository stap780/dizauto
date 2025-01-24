class AddColumnBarcodeToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :barcode, :string
  end
end
