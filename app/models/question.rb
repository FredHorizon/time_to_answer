class Question < ApplicationRecord
  belongs_to :subject, inverse_of: :questions

  has_many :answers # uma questão possui muitas respostas

  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  # Kaminari
  paginates_per 5

  # Scopes
  scope :_search_, -> (page,term){ # nome 'search' foi modificado pra evitar conflitos na aplicação.
            includes(:answers)
            .where("lower(description) LIKE ?", "%#{term.downcase}%")
            .page(page)
  }

  scope :last_question, -> (page){
    includes(:answers).order('created_at desc').page(page)
  }
end
