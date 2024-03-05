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
        answers.create(quiz_id: self.id,answer_text: answer_text,answer_succeed: is_answer_succeed?(answer_text))
    end

    def one_quiz_to_answer_num
        answers.count
    end

    def question_message
        str = '問題！このポケモンはなんでしょう？ '+pokemon_id.to_s
        question_message = {
            type: 'text',
            text: str
        }
    end

    def image_message
        image_path = 'images/gray'+pokemon_id.to_s+'.png'
        image_message = {
            type: 'image',
            originalContentUrl: asset_url(image_path), 
            previewImageUrl: asset_url(image_path)
        }
    end

    def reply_message
        if answers.last.answer_succeed == true
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

    def is_answer_succeed?(input_text)
        return false if validate_text?(input_text)
        answer_text = "ピカチュウ" #仮
        if  input_text == answer_text
            true
        else
            false
        end
    end

    def validate_text?(input_text)
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
    def is_katakana?(text)
        return true if text =~ /\A[ァ-ヶー－]+\z/
        false
    end 
end