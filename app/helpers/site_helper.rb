module SiteHelper
    def msg_jumbotron
        case params[:action]
        when 'index'
            "Perguntas adicionadas recentemente."
        when 'questions'
            "Resultados para: \"#{params[:term]}\"..."
        when 'subject'
            "Questões do assunto \"#{params[:subject]}\"..."
        end
    end
end
