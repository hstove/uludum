class AddFreeAnswerToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :free_answer, :string
    add_column :questions, :multiple_choice, :boolean
  end
end
