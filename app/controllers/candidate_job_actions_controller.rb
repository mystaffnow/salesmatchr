class CandidateJobActionsController < ApplicationController
  before_action :set_candidate_job_action, only: [:show, :edit, :update, :destroy]

  # GET /candidate_job_actions
  # GET /candidate_job_actions.json
  def index
    @candidate_job_actions = CandidateJobAction.all
  end

  # GET /candidate_job_actions/1
  # GET /candidate_job_actions/1.json
  def show
  end

  # GET /candidate_job_actions/new
  def new
    @candidate_job_action = CandidateJobAction.new
  end

  # GET /candidate_job_actions/1/edit
  def edit
  end
  def candidate_job_saved
    @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id, is_saved: true)
  end
  def candidate_job_viewed
    @candidate_job_action = CandidateJobAction.where(candidate_id: current_candidate.id).order('created_at DESC')
  end
  def candidate_matches
    @jobs = Job.where("archetype_low <= ? and archetype_high >= ?", current_candidate.archetype_score, current_candidate.archetype_score)
  end

  # POST /candidate_job_actions
  # POST /candidate_job_actions.json
  def create
    @candidate_job_action = CandidateJobAction.where(job_id: candidate_job_action_params[:job_id], candidate_id: candidate_job_action_params[:candidate_id]).first
    logger.debug(@candidate_job_action.inspect)
    if !@candidate_job_action
      @candidate_job_action = CandidateJobAction.new(candidate_job_action_params)
    else
      @candidate_job_action.is_saved = true
    end
    respond_to do |format|
      if @candidate_job_action.save
        format.html { redirect_to jobs_path, notice: 'Job Saved!' }
        format.json { render :show, status: :created, location: @candidate_job_action }
      else
        format.html { render :new }
        format.json { render json: @candidate_job_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidate_job_actions/1
  # PATCH/PUT /candidate_job_actions/1.json
  def update
    respond_to do |format|
      if @candidate_job_action.update(candidate_job_action_params)
        format.html { redirect_to @candidate_job_action, notice: 'Candidate job action was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate_job_action }
      else
        format.html { render :edit }
        format.json { render json: @candidate_job_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_job_actions/1
  # DELETE /candidate_job_actions/1.json
  def destroy
    @candidate_job_action.destroy
    respond_to do |format|
      format.html { redirect_to candidate_job_actions_url, notice: 'Candidate job action was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate_job_action
      @candidate_job_action = CandidateJobAction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_job_action_params
      params.require(:candidate_job_action).permit(:candidate_id, :job_id, :is_saved)
    end
end
