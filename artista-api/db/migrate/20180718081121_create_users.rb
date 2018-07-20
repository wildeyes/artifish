class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :is_verified
      t.string :verification_code
      t.string :first_name, :null => false
      t.string :last_name, :null => false

      ## unique oauth id
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false

      t.timestamps
    end

    add_index :users, [:email, :provider], unique: true
    add_index :users, [:uid, :provider],   unique: true
  end
end
