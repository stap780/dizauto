class CreateIncaseTips < ActiveRecord::Migration[7.0]
  def change
    create_table :incase_tips do |t|
      t.string :title
      t.string :color

      t.timestamps
    end
  end
end
