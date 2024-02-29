class Answer < ApplicationRecord
    belongs_to :quiz

    def insert_answer(user_line_id,input_text)
        user_id = User.find_by(user_line_id: user_line_id).id
        quiz=Quiz.find_by(user_id: user_id)
        Answer.create(quiz_id: quiz.id, answer_text: input_text, answer_succeed: is_answer_succeed?(input_text))
    end

    def one_quiz_to_answer_num(user_line_id)
        user_id = User.find_by(user_line_id: user_line_id).id
        now_quiz_id=Quiz.where(user_id: user_id).order(updated_at: :desc).limit(1)
        Answer.where(quiz_id: now_quiz_id).count
    end

    private 

    def is_answer_succeed? input_text
        return false if is_kanji? input_text 
        if is_kana? input_text
            text=to_kana(text)
        end
        #APIを呼び出し日本語名と一致するかを確認する
        answer_text = "ピカチュウ" #仮
        if  text == answer_text
            true
        else
            false
        end
    end

    def to_kana(text)
        text.tr('ぁ-ん','ァ-ン')
    end

    def is_kana?(text)
        return true if text =~ /\A[ぁ-んー－]+\z/
        false
    end
    
    def is_kanji?(text)
        return true if text =~ /^[一-龥]+$/
        false
    end
end
