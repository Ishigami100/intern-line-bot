class Answer < ApplicationRecord
    belongs_to :quiz

    def self.insert_answer(user_line_id,input_text)
        now_quiz_id = Quiz.new.get_now_quiz(user_line_id)
        Answer.create(quiz_id: now_quiz_id, answer_text: input_text, answer_succeed: is_answer_succeed?(input_text))
    end

    def one_quiz_to_answer_num(user_line_id)
        now_quiz_id = Quiz.new.get_now_quiz(user_line_id).id
        Answer.where(quiz_id: now_quiz_id).count
    end

    private 

    #送られた答えに漢字もしくはひらがなが含まれていた場合は、かな変換し、正しいかを確認するメソッド

    def is_answer_succeed?(input_text)
        return false if validate_text?(input_text)
        answer_text = "ピカチュウ" #仮
        if  text == answer_text
            true
        else
            false
        end
    end

    def validate_text?(input_text)
        return false if is_katakana?
        #ここにvalidatonを追記する
        return true
    end

    #ひら→カタ
    def to_kana(text)
        text.tr('ぁ-ん','ァ-ン')
    end

    #ひらがな？
    def is_kana?(text)
        return true if text =~ /\A[ぁ-んー－]+\z/
        false
    end

    #漢字？
    def is_kanji?(text)
        return true if text =~ /^[一-龥]+$/
        false
    end

    #カタカナ？
    def is_katakana?(text)
        return true if text =~ /\A[ァ-ヶー－]+\z/
        false
    end
        
end
