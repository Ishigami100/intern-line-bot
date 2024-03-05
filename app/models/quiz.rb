class Quiz < ApplicationRecord
    CHALLENGE_UPPER_LIMIT = 5
    MAX_POKEMON_ID = 150

    belongs_to :user 
    has_many :answers

    def self.start_quiz(line_user_id)
        user_id = User.find_by!(line_user_id: line_user_id).id
        Quiz.create(user_id: user_id, pokemon_id: random_pokemon_id, challenge_upper_limit: CHALLENGE_UPPER_LIMIT)
    end

    def answer(answer_text:)
        answers.create(quiz_id: self.quiz_id,answer_text: answer_text,answer_succeed: self.is_answer_succeed?(answer_text))
    end

    private 

    def self.random_pokemon_id
        rand(1..MAX_POKEMON_ID)
    end

    def self.is_answer_succeed?(input_text)
        return false if validate_text?(input_text)
        answer_text = "ピカチュウ" #仮
        if  text == answer_text
            true
        else
            false
        end
    end

    def self.validate_text?(input_text)
        return false if is_katakana?(input_text)
        #ここにvalidatonを追記する
        return true
    end

    #ひら→カタ
    def self.to_kana(text)
        text.tr('ぁ-ん','ァ-ン')
    end

    #ひらがな？
    def self.is_kana?(text)
        return true if text =~ /\A[ぁ-んー－]+\z/
        false
    end

    #漢字？
    def self.is_kanji?(text)
        return true if text =~ /^[一-龥]+$/
        false
    end

    #カタカナ？
    def self.is_katakana?(text)
        return true if text =~ /\A[ァ-ヶー－]+\z/
        false
    end 
end