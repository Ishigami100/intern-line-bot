class User < ApplicationRecord
    has_many :quizzes

    def current_quiz
        quizzes.last # id の最後が最新だと仮定してますが、厳格にやるなら日付でソートしてもよいかも
    end
end
