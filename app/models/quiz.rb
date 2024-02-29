class Quiz < ApplicationRecord
    CHALLENGE_UPPER_LIMIT = 5
    MAX_POKEMON_ID = 150

    belongs_to :user 
    has_many :answers

    def insert_quiz(user_line_id)
        user_id = User.find_by(user_line_id: user_line_id).id
        Quiz.create(user_id: user_id, pokemon_id: random_pokemon_id, challenge_upper_limit: CHALLENGE_UPPER_LIMIT)
    end

    private 

    def random_pokemon_id
        rand(1..MAX_POKEMON_ID)#ポケモンの個体数に依存する
    end

end
