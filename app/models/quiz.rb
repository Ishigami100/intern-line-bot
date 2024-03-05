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

    def one_quiz_to_answer_num(user_line_id)
        answers.count
    end

    def question_message

        question_message = {
            type: 'text',
            text: '問題！このポケモンはなんでしょう？ '+pokemon_id
        }
    end

    def image_message
        
        image_message = {
            type: 'image',
            originalContentUrl: 'https://cdn.shibe.online/shibes/907fed97467e36f3075211872d98f407398126c4.jpg', 
            previewImageUrl: 'https://cdn.shibe.online/shibes/907fed97467e36f3075211872d98f407398126c4.jpg'
        }
    end

    def reply_message
        if answers.last == true
            message = '正解！！'
        else
            if answers.count >=  CHALLENGE_UPPER_LIMIT
                message = '残念でした。また次回挑戦してください。'
            else
                message =  '違います。再度答えを入力してください。'
            end
        end
        question_message = {
            type: 'text',
            text: message
        }
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