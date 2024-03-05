class Answer < ApplicationRecord
    belongs_to :quiz

    def one_quiz_to_answer_num(user_line_id)
        now_quiz_id = Quiz.new.get_now_quiz(user_line_id).id
        Answer.where(quiz_id: now_quiz_id).count
    end
end
