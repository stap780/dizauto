class AddColumnTipToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :tip, :string
  end
end
