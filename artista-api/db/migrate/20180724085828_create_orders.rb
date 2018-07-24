class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :address
      t.string :zip_code
      t.string :phone_number
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
