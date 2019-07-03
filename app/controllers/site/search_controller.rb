class Site::SearchController < SiteController
    def questions
        @questions = Question.includes(:answers).page(params[:page]) # correção dos selects
    end 
end
