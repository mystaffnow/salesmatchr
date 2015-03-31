class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :inactivate_job, :employer_show]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all
    @jobs_str = "showing " + @jobs.count.to_s + " jobs"
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  def employer_show

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
    @job.employer_id = current_employer.id
    respond_to do |format|
      if @job.save
        format.html { redirect_to employer_jobs_path, notice: 'Job was successfully created.' }
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
      params.require(:job).permit(:employer_id, :city, :state_id, :archetype_low, :archetype_high, :salary_low, :salary_high, :zip, :is_remote, :title, :description, :is_active)
    end
end
