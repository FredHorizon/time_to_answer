class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  has_one :user_profile # usuário possui um perfil do usuário
  accepts_nested_attributes_for :user_profile, reject_if: :all_blank

  # Callback
  after_create :set_statistic # Após criar um admin, registre no banco a estatística (trigger)


  # validations
  validates :first_name, presence: true, length: { minimum: 4 }, on: :update # primeiro nome não pode estar em branco, é campo obrigatório. Validação apenas no update 'on update'


  # Virtual Attributes
  def full_name
    [self.first_name, self.last_name].join(" ")
  end

  private

  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_users])
  end
end
