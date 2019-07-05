class Site::SearchController < SiteController
    def questions
        @questions = Question._search_(params[:page], params[:term]) # método search setado diretamente.Não foi preciso instanciar a classe Question.
    end 
end
