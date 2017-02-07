class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :inactivate_job, :employer_show, :employer_show_actions, :employer_show_matches, :employer_show_shortlists]
  before_action :authenticate_employer!, only: [:new, :create, :edit, :update,
                                                 :destroy, :employer_index, :employer_archive,
                                                 :employer_show, :employer_show_actions,
                                                 :employer_show_matches, :employer_show_shortlists,
                                                 :employer_index, :employer_archive, :inactivate_job
                                               ]
  # GET /jobs
  # GET /jobs.json
  def index
    # :(
    redirect_to candidate_matches_path
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
    authorize(@job)
    if params.permit(:copy_id)[:copy_id]
      job_copy = Job.find(params.permit(:copy_id)[:copy_id])
      attributes = job_copy.attributes.select do |attr, value|
        value != nil
      end
      @job.assign_attributes(attributes)
      @job.id = nil
    end
    if current_employer.jobs.count >= 2
      @should_pay = true
    else
      @should_pay = false
    end
  end

  def send_intro
    @job = Job.find(params[:id])
    @candidate = Candidate.find(params[:candidate_id])

    CandidateMailer.send_job_intro(@candidate.email, @job).deliver
    render json: :ok
  end

  # GET /jobs/1/edit
  def edit
    authorize @job
  end

  def employer_show
    authorize @job

    @job.job_candidates
        .where(status: JobCandidate.statuses[:submitted])
        .map { |jc| jc.viewed! }

    @job_candidates = @job.job_candidates.where("status NOT IN (?)", [JobCandidate.statuses[:shortlist],
                                                    JobCandidate.statuses[:deleted]])
  end

  def employer_show_actions
    authorize @job
  end

  def employer_show_matches
    authorize @job
  end

  def employer_show_shortlists
    authorize @job
    @shortlists = JobCandidate.where(:job_id => params[:id], :status => JobCandidate.statuses[:shortlist])
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
    authorize @job
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
    authorize(@job)
    job_function = JobFunction.find(job_params[:job_function_id])
    @job.archetype_low = job_function.low
    @job.archetype_high = job_function.high
    @job.employer_id = current_employer.id
    @job.job_function_id = job_function.id

    if @job.stripe_token
      charge = Stripe::Charge.create(
          :amount => 15000, # amount in cents, again
          :currency => "usd",
          :source => @job.stripe_token,
          :description => current_employer.company
        )
    end

    tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
    tracker.track('employer-'+@job.employer.email, 'job created')

    respond_to do |format|
      if @job.save
        format.html { redirect_to employer_archive_jobs_path, notice: 'Job was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def employer_job_checkout

  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    authorize(@job)
    job_function = JobFunction.find(job_params[:job_function_id])
    @job.archetype_low = job_function.low
    @job.archetype_high = job_function.high
    @job.job_function_id = job_function.id
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to employer_jobs_path, notice: 'Job was successfully updated.' }
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
    authorize(@job)
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
    params.require(:job).permit(:distance, :job_function_id,:employer_id, :city, :state_id, :archetype_low, :archetype_high, :salary_low, :salary_high, :zip, :is_remote, :title, :description, :is_active, :experience_years, :stripe_token)
  end
end
