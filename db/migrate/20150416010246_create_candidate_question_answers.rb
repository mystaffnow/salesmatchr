class CreateCandidateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :candidate_question_answers do |t|
      t.integer :candidate_id
      t.integer :question_id
      t.integer :answer_id

      t.timestamps null: false
    end
  end
end
