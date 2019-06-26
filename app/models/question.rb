class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions

  has_many :answers # uma questão possui muitas respostas

  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true
end
