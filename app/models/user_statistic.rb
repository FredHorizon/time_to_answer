class UserStatistic < ApplicationRecord
  belongs_to :user

  # Virtual Attributes
  def total_questions
    self.right_questions + self.wrong_questions
  end

  # Class method
  def self.set_statistic(answer, current_user, user_signed_in)
    if user_signed_in # o devise só permite a chamada direta desse helper no controller ou view. Aqui no model dará erro, por isso ele precisa ir como parâmetro.
      user_statistic = UserStatistic.find_or_create_by(user: current_user)
      answer.correct? ? user_statistic.right_questions += 1 : user_statistic.wrong_questions += 1
      user_statistic.save
    end
  end

end