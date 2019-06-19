class CreateSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :subjects do |t|
      t.string :description, null: false # a descrição não pode ficar em branco

      t.timestamps
    end
  end
end
