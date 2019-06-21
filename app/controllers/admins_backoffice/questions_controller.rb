class AdminsBackoffice::QuestionsController < AdminsBackofficeController
	before_action :set_question, only: [:edit, :update, :destroy]
	
	def index
		@questions = Question.all.order(:description).page(params[:page])
	end
	
	def new
		@questions = Question.new
	end
	
	def create
		@questions = Question.new(params_question)
		if @questions.save
		redirect_to admins_backoffice_questions_path, notice: "Questão cadastrada com sucesso!"
		else
		render :new
		end
	end
	
	def edit
	end
	
	def update
		if @questions.update(params_question)
		redirect_to admins_backoffice_questions_path, notice: "Questão atualizada com sucesso!"
		else
		render :edit
		end
	end
	
	def destroy
		if @questions.destroy
		redirect_to admins_backoffice_questions_path, notice: "Questão excluída com sucesso!"
		else
		render :index
		end
	end
	
	private
	
	def params_question
		params.require(:question).permit(:description)
	end
	
	def set_question
		@questions = Question.find(params[:id])
	end
end
