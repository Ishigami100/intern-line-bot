class Quiz < ApplicationRecord
    CHALLENGE_UPPER_LIMIT = 5
    MAX_POKEMON_ID = 150

    belongs_to :user 
    has_many :answers

    def self.insert_quiz(line_user_id)
        p line_user_id
        user_id = User.find_by!(line_user_id: line_user_id).id
        Quiz.create(user_id: user_id, pokemon_id: random_pokemon_id, challenge_upper_limit: CHALLENGE_UPPER_LIMIT)
    end

    def get_now_quiz(line_user_id)
        user_id = User.find_by!(line_user_id: line_user_id).id
        now_quiz_id=Quiz.where(user_id: user_id).first
    end

    private 

    def self.random_pokemon_id
        rand(1..MAX_POKEMON_ID)#ポケモンの個体数に依存する
    end

end
