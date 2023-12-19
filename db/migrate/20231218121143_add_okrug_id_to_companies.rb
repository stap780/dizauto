class AddOkrugIdToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :okrug_id, :integer
  end
end
