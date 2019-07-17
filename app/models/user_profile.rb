class UserProfile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar # O perfil do usuário possui um anexo chamado avatar
end
