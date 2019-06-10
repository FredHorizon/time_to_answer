namespace :dev do

  DEFAULT_PASSWORD = 123456
  
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    # '%x' permite a execução de comandos de terminal diretamente da apliacação.
    # puts %x(rails db:drop db:create db:migrate db:seed)
    
    if Rails.env.development?
      show_spinner("Criando BD...") { %x(rails db:create) }
      show_spinner("Migrando BD...") { %x(rails db:migrate) }
      show_spinner("Cadastrando o administrador padrão...") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando o administradores extras...") { %x(rails dev:add_fakes_admin) }
      show_spinner("Cadastrando o usuário padrão...") { %x(rails dev:add_default_user) }
      # %x(rails dev:add_mining_types)
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

  private

  def show_spinner(msg_start, msg_end = "Conluído com sucesso!") # parâmetros de mensagem de início e final. A de final será por padrão 'Concluído com sucesso', caso não seja setada
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield # executará o trecho de código em <if Rails.env.development? ... end>
    spinner.success("(#{msg_end})")
  end

end
