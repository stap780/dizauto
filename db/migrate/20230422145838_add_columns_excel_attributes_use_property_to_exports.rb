class AddColumnsExcelAttributesUsePropertyToExports < ActiveRecord::Migration[7.0]
  def change
    add_column :exports, :excel_attributes, :string
    add_column :exports, :use_property, :boolean
  end
end
