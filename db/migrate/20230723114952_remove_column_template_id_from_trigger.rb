class RemoveColumnTemplateIdFromTrigger < ActiveRecord::Migration[7.0]
  def change
    remove_column :triggers, :template_id
  end
end
