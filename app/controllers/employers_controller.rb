class EmployersController < ApplicationController
  skip_before_filter :check_employer, only: [:account, :update, :add_payment_method,
                                                :insert_payment_method]
  before_action :authenticate_employer!, only: [:profile, :update,
                                                :account, :add_payment_method,
                                                :insert_payment_method]
  before_action :set_profile, only: [:profile, :account, :update]

  # view employer's profile, signed in employer can access this
  def profile
    authorize @profile
  end

  # submit account information, signed in employer can access this
  def account
    # authorize @profile
    current_employer.build_employer_profile if !current_employer.employer_profile
  end

  # update profile information of employer, signed in employer can access this
  def update
    # authorize @profile
    respond_to do |format|
      if current_employer.update(employer_params)
        current_employer.save
        format.html { redirect_to employers_profile_path,
                      notice: 'Profile was successfully updated.' }
      else
        format.html { render :account }
      end
    end
  end

  # Get employer profile publicly, signed in employer or candidate can access this
  def public
    @employer = Employer.find(params[:id])
    @profile = @employer.try(:employer_profile)
  end

  # Employer has to add valid payment information to use services like making job active
  # current_employer can access this
  def add_payment_method
    @customer = Customer.new
  end

  # add payment information of employer
  def insert_payment_method
    @customer = Customer.new(customer_params)
    pay_service = Services::Pay.new(current_employer, nil, @customer.stripe_card_token)

    if pay_service.is_customer_saved?
      redirect_to employers_payment_methods_path,
                  notice: 'You have successfully added your payment information!'
    else
      render :add_payment_method
    end
  end

  # list payment methods
  def list_payment_method
    @payment_methods = Customer.all
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def employer_params
    params.require(:employer).permit(:first_name, :last_name,
        :employer_profile_attributes => [
          :id, :website, :ziggeo_token, :avatar, :zip, :city, :state_id, :description
        ])
  end

  def customer_params
    params.require(:customer).permit(:stripe_card_token)
  end

  def set_profile
    @profile = EmployerProfile.find_or_initialize_by(employer_id: current_employer.id)
  end
end