class User < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 20
      t.timestamps
    end
  end
end
