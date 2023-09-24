class AddColumnTipAndModelnameToTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :templates, :tip, :string
    add_column :templates, :modelname, :string
  end
end
