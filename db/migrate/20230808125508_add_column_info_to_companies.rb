class AddColumnInfoToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :info, :string
  end
end
