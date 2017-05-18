class AddIndexesOnCandidateQuestionAnswers < ActiveRecord::Migration
  def change
    # question asked to the candidate should not repeat again
    add_index :candidate_question_answers, [:candidate_id, :question_id], unique: true, name: 'uniq_index_candidate_id_and_question_id'
    add_index :candidate_question_answers, :candidate_id
    add_index :candidate_question_answers, :question_id #
    add_index :candidate_question_answers, :answer_id
  end
end
