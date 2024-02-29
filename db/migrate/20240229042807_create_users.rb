class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users , id: false do |t|
      t.column :user_id, 'INT PRIMARY KEY AUTO_INCREMENT', null: false
      t.string :user_id, null: false , unique: true

      t.timestamps
    end
  end
end
