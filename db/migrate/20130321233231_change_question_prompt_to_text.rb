class ChangeQuestionPromptToText < ActiveRecord::Migration
  def change
    change_column :questions, :prompt, :text
  end
end
