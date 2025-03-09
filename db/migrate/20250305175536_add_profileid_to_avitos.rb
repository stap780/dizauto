class AddProfileidToAvitos < ActiveRecord::Migration[7.1]
  def change
    add_column :avitos, :profileid, :integer
  end
end
