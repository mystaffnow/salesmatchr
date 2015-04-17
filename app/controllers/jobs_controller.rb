class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :inactivate_job, :employer_show, :employer_show_actions, :employer_show_matches]

  # GET /jobs
  # GET /jobs.json
  def index
    h = { }
    h[:is_active] = true
    @jobs_str = ""
    if params[:job_function] != '' && params[:job_function]
      h[:job_function_id] = params[:job_function]
      job_function = JobFunction.find(params[:job_function])
      @jobs_str = @jobs_str + "for " + job_function.name + " "
    end
    if params[:is_remote] != '' && params[:is_remote]
      h[:is_remote] = params[:is_remote]
      @jobs_str = @jobs_str + "that are " + ( params[:is_remote] ? '' : 'not ') + " remote "
    end
    #assume if one is set then the other is too.... is using the slider
    if params[:salary_low] != '' && params[:salary_low]
      h[:salary_low] = params[:salary_low]..params[:salary_high]
      h[:salary_high] = params[:salary_low]..params[:salary_high]
      @jobs_str = @jobs_str + " and have salaries between $" + params[:salary_low] + " and $" + params[:salary_high]
    end
    if params[:zip] != '' && params[:zip]
      res = Integer(params[:distance]) rescue false
      if res
        distance = params[:distance]
      else
        distance = 10
      end
      @jobs_str = @jobs_str + " within " + distance.to_s + " miles of " + params[:zip]
      @jobs = Job.near(params[:zip], distance.to_i).where(h)
    else
      @jobs = Job.where(h)
    end
    @jobs_str = "Displaying " + @jobs.count(:all).to_s + " results " + @jobs_str
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    if current_candidate
      @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id, job_id: @job.id).first
      if !@candidate_job_action
        current_candidate.view_job(@job)
      end
    end
  end

  # GET /jobs/new
  def new
    @job = Job.new
    if params.permit(:copy_id)[:copy_id]
      job_copy = Job.find(params.permit(:copy_id)[:copy_id])
      attributes = job_copy.attributes.select do |attr, value|
        value != nil
      end
      @job.assign_attributes(attributes)
      @job.id = nil
    end
  end

  # GET /jobs/1/edit
  def edit
  end

  def employer_show
    @job.job_candidates.each do |job_candidate|
      if job_candidate.submitted?
        job_candidate.viewed!
      end
    end
  end
  def employer_show_actions

  end
  def employer_show_matches

  end
  def employer_index
    @jobs = Job.where(employer_id: current_employer.id, is_active: true )
    @inactive_job_count = Job.where(employer_id: current_employer.id, is_active: false ).count
  end

  def employer_archive
    @jobs = Job.where(employer_id: current_employer.id, is_active: false )
    @active_job_count = Job.where(employer_id: current_employer.id, is_active: true ).count
  end
  def inactivate_job
    @job.is_active = !@job.is_active
    @job.save
    respond_to do |format|
      format.html { redirect_to employer_jobs_path, notice: 'Job was successfully updated.' }
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    job_function = JobFunction.find(job_params[:job_function_id])
    @job.archetype_low = job_function.low
    @job.archetype_high = job_function.high
    @job.employer_id = current_employer.id
    @job.job_function_id = job_function.id
    respond_to do |format|
      if @job.save
        format.html { redirect_to employer_archive_jobs_path, notice: 'Job was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to employers_job_path, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:distance, :job_function_id,:employer_id, :city, :state_id, :archetype_low, :archetype_high, :salary_low, :salary_high, :zip, :is_remote, :title, :description, :is_active)
    end
end
