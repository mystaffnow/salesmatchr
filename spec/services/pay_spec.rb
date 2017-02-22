require 'rails_helper'

RSpec.describe Services::Pay do
	let(:state) {create(:state)}
	let(:employer) {create(:employer)}
  let(:job) {
      create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900",
                    archetype_low: -30, archetype_high: 70, city: 'city1', state_id: state.id
                    )
            }
  let(:stripe_card_token) {generate_stripe_card_token}

  it 'should create stripe customer' do
  	stripe_cus = Services::Pay.new(employer, job, stripe_card_token)
  	expect(stripe_cus.employer).to be_a(Employer)
  	expect(stripe_cus.job).to be_a(Job)
  	expect(stripe_cus.stripe_card_token).to eq(stripe_card_token)
  	expect(stripe_cus.stripe_customer).to be_a(Stripe::Customer)
  end

  it 'should create payment' do
  	stripe_cus = Services::Pay.new(employer, job, stripe_card_token)
  	payment = stripe_cus.process_payment
  	expect(payment).to be_a(Payment)
  	expect(payment.employer_id).to eq(employer.id)
  	expect(payment.job_id).to eq(job.id)
  	expect(payment.amount).to eq(190.0)
  	expect(payment.stripe_card_token).to eq(stripe_card_token)
  	expect(payment.stripe_customer_id).to eq(stripe_cus.stripe_customer.id)
  end

  it 'should create stripe charge' do
  	stripe_cus = Services::Pay.new(employer, job, stripe_card_token)
  	stripe_charge = stripe_cus.create_stripe_charge
  	expect(stripe_charge).not_to be_nil
  end

  it 'should return nil' do
  	stripe_cus = Services::Pay.new(nil, nil, nil)
  	expect(stripe_cus.process_payment).to be_nil
  	expect(stripe_cus.create_stripe_charge).to be_nil
  end
end