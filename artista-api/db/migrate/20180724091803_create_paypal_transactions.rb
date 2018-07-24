class CreatePaypalTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :paypal_transactions do |t|
      t.string :token
      t.string :payer
      t.string :processor_authorization_code
      t.monetize :amount
      t.boolean :success
      t.references :order, foreign_key: true

      t.timestamps
    end
    add_index :paypal_transactions, :token, unique: true
  end
end
