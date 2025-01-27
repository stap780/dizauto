class AddColumnsReceiverValueAndAttachmentToTempls < ActiveRecord::Migration[7.1]
  def change
    add_column :templs, :receiver_value, :string
    add_column :templs, :print_template_id, :integer
  end
end
