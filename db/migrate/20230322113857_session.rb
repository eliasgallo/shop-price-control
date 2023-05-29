class Session < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.belongs_to :user
      t.string :token
      t.string :ip_address
      t.timestamps
    end
  end
end
