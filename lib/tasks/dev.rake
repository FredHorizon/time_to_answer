namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')
  
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    # '%x' permite a execução de comandos de terminal diretamente da apliacação.
    # puts %x(rails db:drop db:create db:migrate db:seed)
    
    if Rails.env.development?
      show_spinner("Apagando BD...") { %x(rails db:drop) }
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Cadastrando o administrador padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando os administradores extras...") { %x(rails dev:add_fakes_admin) }
      show_spinner("Cadastrando o usuário padrão...") { %x(rails dev:add_default_user) }
      show_spinner("Cadastrando assuntos padrões...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando perguntas e respostas...") { %x(rails dev:add_answers_and_questions) }
    else
      puts "Você não está em modo de desenvolvimento!"
    end
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!( # Aqui não precisa usar o <Admin.find_or_create_by!(admin)> porque o devise já possui esse método implementado internamente, ou seja, ele mesmo faz essa verificação se existe algum 'admin', 'email' ou 'senha' já cadastrado.
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona administradores fake"
  task add_fakes_admin: :environment do
    10.times do |i| # cria 10 administradores
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona assuntos padrão"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line| # 'r' somente leitura
      Subject.create!(description: line.strip) # .strip tira oculta o '/n', que são os espaços das palavras de cada linha
    end
  end

  desc "Adiciona perguntas e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject| # Assunto
      rand(5..10).times do |i| # Para cada um dos Assuntos, cria entre 5 e 10 Questões
        params = create_question_params(subject) #1 Pega os parâmetros
        answers_array = params[:question][:answers_attributes] #2 Separa o array das respostas
          
        add_answers(answers_array) #3 Adiciona as respostas
        elect_true_answer(answers_array) #4 Elege uma resposta verdadeira

        Question.create!( params[:question]) # Por fim, pega os parâmetros com as devidas alterações e salva
      end
    end
  end

  desc "Reseta o contador dos assuntos"
  task reset_subject_counter: :environment do
    show_spinner("Resetando o contador dos assuntos...") do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  private

  def create_question_params(subject = Subject.all.sample) #1
    { question: {
        description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
        subject: subject,
        answers_attributes: [] #2
      }
    }
  end

  def create_answer_params(correct = false)
    { description: Faker::Lorem.sentence, correct: correct }
  end

  def add_answers(answers_array = []) #3
    rand(2..5).times do |j|
      answers_array.push(
        create_answer_params
      )
    end
  end

  def elect_true_answer(answers_array = []) #4
    selected_index = rand(answers_array.size)
    answers_array[selected_index] = create_answer_params(true)
  end

  def show_spinner(msg_start, msg_end = "Conluído com sucesso!") # parâmetros de mensagem de início e final. A de final será por padrão 'Concluído com sucesso', caso não seja setada
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield # executará o trecho de código em <if Rails.env.development? ... end>
    spinner.success("(#{msg_end})")
  end

end
