class AddTelegramToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :telegram, :string
  end
end
