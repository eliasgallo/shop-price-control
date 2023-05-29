class CreatePriceOfferItem < ActiveRecord::Migration[7.0]
  def change
    create_table :price_offer_items do |t|
      t.string :name
      t.float :comparison_price
      t.string :comparison_price_unit
      t.string :reliability
      t.string :category
      t.string :tags, array: true, default: [], null: false
      t.belongs_to :user
      t.timestamps
    end
  end
end
