class AddFreeAnswerSuffixToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answer_prefix, :string
    add_column :questions, :answer_suffix, :string
  end
end
