class AddTypeAndEnabledToMaterial < ActiveRecord::Migration[5.2]
  def change
    add_column :materials, :material_type, :string, null: false
    add_column :materials, :enabled, :boolean, default: false

    remove_index :materials, :name
    add_index :materials, [:material_type, :name], unique: true
    add_index :materials, :enabled
  end
end
