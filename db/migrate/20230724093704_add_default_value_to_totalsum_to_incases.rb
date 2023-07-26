class AddDefaultValueToTotalsumToIncases < ActiveRecord::Migration[7.0]
  def change
    Incase.update_all(totalsum: 0)
    change_column_default :incases, :totalsum, from: nil, to: 0
  end
end
