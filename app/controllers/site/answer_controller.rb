class Site::AnswerController < SiteController
  def question
    @answer = Answer.find(params[:answer_id])
    UserStatistic.set_statistic(@answer, current_user, user_signed_in?) # user user_signed_in como parâmetro pra poder ser chamado do model.
  end

end
