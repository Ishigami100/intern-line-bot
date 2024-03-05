class User < ApplicationRecord
    has_many :quizzes

    def current_quiz
        quizzes.last
    end
end
