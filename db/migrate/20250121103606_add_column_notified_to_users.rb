class AddColumnNotifiedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :notified, :boolean, default: false
  end
end
