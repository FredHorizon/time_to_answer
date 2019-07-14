class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # validations
  validates :first_name, presence: true, length: { minimum: 4 }, on: :update # primeiro nome não pode estar em branco, é campo obrigatório. Validação apenas no update 'on update'


  # Virtual Attributes
  def full_name
    [self.first_name, self.last_name].join(" ")
  end
end
