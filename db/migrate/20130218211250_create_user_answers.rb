class CreateUserAnswers < ActiveRecord::Migration
  def change
    create_table :user_answers do |t|
      t.integer :user_id
      t.integer :question_id
      t.string :free_answer
      t.integer :attempts
      t.integer :last_answer_id
      t.boolean :correct

      t.timestamps
    end
  end
end
