class CreateExports < ActiveRecord::Migration[7.0]
  def change
    create_table :exports do |t|
      t.string :title
      t.string :link
      t.text :template
      t.string :time
      t.string :format

      t.timestamps
    end
  end
end
