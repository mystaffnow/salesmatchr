require 'test_helper'

class CandidateJobActionsControllerTest < ActionController::TestCase
  setup do
    @candidate_job_action = candidate_job_actions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:candidate_job_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create candidate_job_action" do
    assert_difference('CandidateJobAction.count') do
      post :create, candidate_job_action: { candidate_id: @candidate_job_action.candidate_id, is_saved: @candidate_job_action.is_saved, job_id: @candidate_job_action.job_id }
    end

    assert_redirected_to candidate_job_action_path(assigns(:candidate_job_action))
  end

  test "should show candidate_job_action" do
    get :show, id: @candidate_job_action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @candidate_job_action
    assert_response :success
  end

  test "should update candidate_job_action" do
    patch :update, id: @candidate_job_action, candidate_job_action: { candidate_id: @candidate_job_action.candidate_id, is_saved: @candidate_job_action.is_saved, job_id: @candidate_job_action.job_id }
    assert_redirected_to candidate_job_action_path(assigns(:candidate_job_action))
  end

  test "should destroy candidate_job_action" do
    assert_difference('CandidateJobAction.count', -1) do
      delete :destroy, id: @candidate_job_action
    end

    assert_redirected_to candidate_job_actions_path
  end
end
