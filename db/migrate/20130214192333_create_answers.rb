class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.text :answer

      t.timestamps
    end
    change_column :questions, :prompt, :text
    add_column :questions, :correct_answer_id, :integer
  end
end
