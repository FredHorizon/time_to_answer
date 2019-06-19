class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :description, null: false
      t.references :question, foreign_key: true
      t.boolean :correct, default: false # por padrão as respostas estarão com status de errada quando forem criadas no banco.

      t.timestamps
    end
  end
end
