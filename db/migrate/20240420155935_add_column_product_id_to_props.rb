class AddColumnProductIdToProps < ActiveRecord::Migration[7.1]
  def change
    add_reference :props, :product, foreign_key: true
  end
end
