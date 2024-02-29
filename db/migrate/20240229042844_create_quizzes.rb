class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :pokemon_id , null: false
      t.integer :challenge_upper_limit , null: false

      t.timestamps
    end
  end
end
