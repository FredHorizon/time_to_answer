class Site::WelcomeController < SiteController
  def index
    @questions = Question.last_question(params[:page])
  end
end
