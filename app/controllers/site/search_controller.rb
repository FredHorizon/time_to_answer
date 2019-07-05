class Site::SearchController < SiteController
    def questions
        @questions = Question.search(params[:page], params[:term]) # método search setado diretamente.Não foi preciso instanciar a classe Question.
    end 
end
