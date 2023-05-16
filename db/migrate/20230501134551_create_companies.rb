class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :inn
      t.string :kpp
      t.string :title
      t.string :ur_address
      t.string :fact_address
      t.string :ogrn
      t.string :okpo
      t.string :bik
      t.string :bank_title
      t.string :bank_account

      t.timestamps
    end
  end
end
