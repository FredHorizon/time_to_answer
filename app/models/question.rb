class Question < ApplicationRecord
  belongs_to :subject
  has_many :answers # uma questão possui muitas respostas

  accepts_nested_attributes_for :answers # a questão deve aceitar atributos das respostas
end
