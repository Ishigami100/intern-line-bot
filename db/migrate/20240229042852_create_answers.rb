class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.column :answer_id, 'INT PRIMARY KEY AUTO_INCREMENT', null: false
      t.references :quiz, foreign_key: true, null: false
      t.string :answer_text null: false
      t.boolean :answer_succeed, null: false

      t.timestamps
    end
  end
end
