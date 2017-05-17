require 'rails_helper'

RSpec.describe Services::Pay do
	let(:state) {create(:state)}
	let(:employer) {create(:employer)}
  let(:job_function) {create(:job_function)}
  let(:job) {
      create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900", 
                   city: 'city1', state_id: state.id,job_function_id: job_function.id, is_active: true, status: Job.statuses["enable"])
            }
  let(:stripe_card_token) {generate_stripe_card_token}

  it 'should create stripe customer, and payment should processed' do
  	# constructor
    obj = Services::Pay.new(employer, job, stripe_card_token)
  	expect(obj.stripe_card_token).to eq(stripe_card_token)
    # customer
    expect(obj.is_customer_saved?).to be_truthy    
    expect(Customer.count).to eq(1)
    expect(Customer.first.last4).not_to be_nil
    expect(Customer.first.stripe_customer_id).not_to be_nil
    expect(Customer.first.stripe_card_token).to eq(obj.stripe_card_token)
    expect(Customer.first.exp_month).not_to be_nil
    expect(Customer.first.exp_year).not_to be_nil
    # payment
    expect(obj.is_payment_processed?(Customer.first)).to be_truthy
    expect(Payment.count).to eq(1)
    expect(Payment.first.employer_id).to eq(employer.id)
    expect(Payment.first.job_id).to eq(job.id)
    expect(Payment.first.amount).to eq("#{JOB_POSTING_FEE}".to_i)
    expect(Payment.first.stripe_charge_id).not_to be_nil
    expect(Payment.first.status).to eq("charged")
    expect(Payment.first.customer_id).not_to be_nil
  end

  it 'should return false' do
  	stripe_cus = Services::Pay.new(nil, nil, nil)
  	# when customer object is nil
    expect(stripe_cus.is_payment_processed?(nil)).to be_falsy
  	# when all accessors are nil
    expect(stripe_cus.is_customer_saved?).to be_falsy
  end

  it 'should return false when payment tends to happen from expired card' do
    # constructor
    obj = Services::Pay.new(employer, job, stripe_card_token)
    expect(obj.stripe_card_token).to eq(stripe_card_token)
    # customer
    expect(obj.is_customer_saved?).to be_truthy    
    expect(Customer.count).to eq(1)
    expect(Customer.first.exp_month).not_to be_nil
    expect(Customer.first.exp_year).not_to be_nil
    
    Customer.first.update(exp_month: 1.months.ago.month)
    Customer.first.update(exp_year: 1.years.ago.year)
    expect(obj.is_payment_processed?(Customer.first)).to be_falsy
  
    Customer.first.update(exp_month: 1.years.from_now.month)
    Customer.first.update(exp_year: 1.years.from_now.year)
    expect(obj.is_payment_processed?(Customer.first)).to be_truthy 

    Customer.first.update(exp_month: Timecop.freeze(Time.now.month))
    Customer.first.update(exp_year: Timecop.freeze(Time.now.year))
    expect(obj.is_payment_processed?(Customer.first)).to be_truthy  
  end
end