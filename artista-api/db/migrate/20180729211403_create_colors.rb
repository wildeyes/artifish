class CreateColors < ActiveRecord::Migration[5.2]
  def change
    create_table :colors do |t|
      t.integer :r
      t.integer :g
      t.integer :b
      t.float :h
      t.float :s
      t.float :l
    end
  end
end
