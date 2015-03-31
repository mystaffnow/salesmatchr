require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post :create, job: { description: @job.description, employer_id: @job.employer_id, is_active: @job.is_active, is_remote: @job.is_remote, salary_high: @job.salary_high, salary_low: @job.salary_low, title: @job.title, zip: @job.zip }
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should show job" do
    get :show, id: @job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job
    assert_response :success
  end

  test "should update job" do
    patch :update, id: @job, job: { description: @job.description, employer_id: @job.employer_id, is_active: @job.is_active, is_remote: @job.is_remote, salary_high: @job.salary_high, salary_low: @job.salary_low, title: @job.title, zip: @job.zip }
    assert_redirected_to job_path(assigns(:job))
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete :destroy, id: @job
    end

    assert_redirected_to jobs_path
  end
end
