class RemoveInfoFromCompanies < ActiveRecord::Migration[7.0]
  def change
    remove_column :companies, :info
  end
end
