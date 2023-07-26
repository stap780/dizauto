class CreateClientCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :client_companies do |t|
      t.integer :client_id
      t.integer :company_id

      t.timestamps
    end
  end
end
