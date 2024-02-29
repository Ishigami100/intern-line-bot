class User < ApplicationRecord
    has_many :quizzes

    def insert_user(user_id)
        User.create(line_user_id: user_id)
    end
end
