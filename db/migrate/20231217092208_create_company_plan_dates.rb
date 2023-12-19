class CreateCompanyPlanDates < ActiveRecord::Migration[7.0]
  def change
    create_table :company_plan_dates do |t|
      t.datetime :date
      t.integer :company_id
      t.timestamps
    end
  end
end
