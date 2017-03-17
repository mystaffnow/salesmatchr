class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy,
                                 :inactivate_job, :employer_show,
                                 :employer_show_actions, :employer_show_matches,
                                 :employer_show_shortlists, :employer_show_remove,
                                 :email_match_candidates]
  before_action :authenticate_employer!, only: [:new, :create, :edit, :update,
                                                 :destroy, :employer_archive,
                                                 :employer_show, :employer_show_actions,
                                                 :employer_show_matches, :employer_show_shortlists,
                                                 :employer_index, :employer_archive, :inactivate_job,
                                                 :employer_show_remove, :email_match_candidates
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
    authorize(@job)
    if current_candidate
      @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id, job_id: @job.id).first
      if !@candidate_job_action
        current_candidate.view_job(@job)
      end
    end
  end

  # signed_in employer required
  # employer can submit new job
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
    @job.build_payment
  end

  # signed_in employer required
  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params.merge(activated_at: DateTime.now))
    authorize(@job)
    job_function = JobFunction.find(job_params[:job_function_id])
    @job.employer_id = current_employer.id
    @job.job_function_id = job_function.id

    stripe_card_token = params["job"]["payment"]["stripe_card_token"]

    respond_to do |format|
      if @job.save
        payment_service = Services::Pay.new(current_employer, @job, stripe_card_token)
        
        ps = payment_service.process_payment

        if ps.nil? # if there is an error while payment
          @job.destroy 
          format.html { redirect_to employer_archive_jobs_path, notice: 'Oops! there is some issue while process payment, please contact techical support.' }        
        else
          result = @job.send_email
          if result.present?
            tracker = Mixpanel::Tracker.new(ENV["NT_MIXPANEL_TOKEN"])
            tracker.track('employer-'+@job.employer.email, 'job created')
            format.html { redirect_to employer_archive_jobs_path, notice: 'Job was successfully created.' }
          else
            format.html { redirect_to employer_archive_jobs_path, notice: 'Oops! we cannot process your request, please contact techical support.' }
          end
        end
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # signed_in employer required
  # GET /jobs/1/edit
  def edit
    authorize @job
  end

  # signed_in employer required
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

  # signed_in employer required
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

  def send_intro
    @job = Job.find(params[:id])
    @candidate = Candidate.find(params[:candidate_id])

    CandidateMailer.send_job_intro(@candidate.email, @job).deliver
    render json: :ok
  end

  # GET: employer_job_actions/:id
  # signed_in employer is required
  # List of all visible candidates who have viewed the job
  def employer_show_actions
    authorize @job
    # @job.candidate_job_actions
    @candidates = Job.visible_candidate_viewed_list(@job)
  end

  # GET: employer_job_matches/:id
  # signed_in employer is required
  # List of all candidates whose profile matched with job
  def employer_show_matches
    authorize @job
    @candidates = @job.candidate_matches_list
  end

  # GET: employer_jobs/:id
  # signed_in employer is required
  # List of the applications who are not removed and shortlisted
  def employer_show
    authorize @job

    @job.job_candidates
        .where(status: JobCandidate.statuses[:submitted])
        .map { |jc| jc.viewed! }

    @job_candidates = @job.job_candidates.where("status NOT IN (?)", [JobCandidate.statuses[:shortlist],
                                                    JobCandidate.statuses[:deleted]])
  end

  # GET: employer_job_shortlists/1
  # signed_in employer is required
  # List of all candidates whose profile is shortlisted
  def employer_show_shortlists
    authorize @job
    @shortlists = JobCandidate.where(:job_id => params[:id], :status => JobCandidate.statuses[:shortlist])
  end

  # GET: employer_job_remove/1
  # signed_in employer is required
  # List of all candidates whose profile is rejected or delted
  def employer_show_remove
    authorize @job
    @removed_job_candidates = JobCandidate.where(:job_id => params[:id], :status => JobCandidate.statuses[:deleted])
  end

  # signed_in employer is required
  # list all open jobs of signed_in employer, count inactive job and open jobs and display on
  # this page and link count views-matches-applicants-shortlist-removed
  def employer_index
    @jobs = Job.enable.where(employer_id: current_employer.id, is_active: true)
    @inactive_job_count = Job.enable.where(employer_id: current_employer.id, is_active: false ).count
  end

  # signed_in employer is required
  # list of inactive jobs, with count of views-matches-applicants
  def employer_archive
    @jobs = Job.enable.where(employer_id: current_employer.id, is_active: false)
    @active_job_count = Job.enable.where(employer_id: current_employer.id, is_active: true ).count
  end

  # signed_in employer is required
  # list of employer's job which is disable by admin
  def list_disable_jobs
    @jobs = Job.disable.where(employer_id: current_employer.id)
  end
  
  # toggle is_active
  def inactivate_job
    authorize @job
    @job.is_active = !@job.is_active
    @job.save
    respond_to do |format|
      format.html { redirect_to employer_jobs_path, notice: 'Job was successfully updated.' }
    end
  end

  def employer_job_checkout

  end

  # Send email to all candidates who matches the job and who have only subscribed to alert feature
  def email_match_candidates
    authorize @job
    result = @job.send_email
    if result.present?
      redirect_to employer_show_matches_path(@job.id), notice: 'Email send to all matched candidates who have subscribed to receive email.'
    else
      redirect_to employer_archive_jobs_path, notice: 'Oops! we cannot process your request, please contact techical support.'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:distance, :job_function_id,:employer_id, :city, :state_id,
                                #:archetype_low, :archetype_high,
                                :salary_low, :salary_high, :zip, :is_remote, :title, :description, 
                                :is_active, :experience_years, :stripe_token,
                                :payment_attributes => [
                                  :id, :stripe_card_token
                                ]
                                )
  end
end
