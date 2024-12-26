class CreateTelegramBots < ActiveRecord::Migration[7.1]
  def change
    create_table :telegram_bots do |t|
      t.string :title
      t.string :token

      t.timestamps
    end
  end
end
