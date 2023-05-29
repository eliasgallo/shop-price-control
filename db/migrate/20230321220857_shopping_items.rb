class ShoppingItems < ActiveRecord::Migration[7.0]
  def change
    create_table :shopping_items do |t|
      t.boolean :checked, null: false, default: false
      t.string :name
      t.boolean :offer, null: false, default: false
      t.float :price
      t.string :price_unit
      t.float :quantity
      t.string :quantity_type
      t.string :store
      t.belongs_to :user
      t.timestamps
    end
  end
end
