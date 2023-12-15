class AddPositionToIncaseStatuses < ActiveRecord::Migration[7.0]
  def change
    add_column :incase_statuses, :position, :integer, null: false, default: 1

    IncaseStatus.order(:updated_at).each.with_index(1) do |i, index|
      i.update_column :position, index
    end

  end
end
