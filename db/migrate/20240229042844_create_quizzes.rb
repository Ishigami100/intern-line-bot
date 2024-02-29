class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :users , id: false do |t|
      t.column :quiz_id, 'INT PRIMARY KEY AUTO_INCREMENT', null: false
      t.integer :user_id, null: false
      t.integer :pokemon_id , null: false
      t.integer :challenge_upper_limit , null: false

      t.timestamps
  end
end
