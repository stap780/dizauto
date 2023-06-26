class AddColumnShortTitleToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :short_title, :string
  end
end
