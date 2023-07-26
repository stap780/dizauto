class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :title
      t.string :subject
      t.string :receiver
      t.text :content

      t.timestamps
    end
  end
end
