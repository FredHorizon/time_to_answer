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
  validates :first_name, presence: true, length: { minimum: 4 }, on: :update, unless: :reset_password_token_present?


  # Virtual Attributes
  def full_name
    [self.first_name, self.last_name].join(" ")
  end

  private

  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_users])
  end

  def reset_password_token_present?
    # params está acessível apenas no controller. O acesso pelo modo se dar por meio de uma variável global 'global_params'
    !!$global_params[:user][:reset_password_token] # duas '!!' transformam a sentença em um valor booleano. Se trouxer o toke, dará verdadeiro. Senão, falso.
  end
end
