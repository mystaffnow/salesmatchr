module Services
	class Pay
		attr_accessor :employer, :job, :stripe_card_token
		JOB_POSTING_FEE = 199

		def initialize(employer, job, stripe_card_token)
			@employer = employer
			@job = job
			@stripe_card_token = stripe_card_token

			@stripe_customer = Stripe::Customer.create(card: stripe_card_token)
		end

		def process_payment
			charge = create_stripe_charge

			Payment.create(
				amount: JOB_POSTING_FEE * 100,
				employer_id: employer.id,
				job_id: job.id,
				stripe_card_token: stripe_card_token, 
				stripe_customer_id: @stripe_customer.id, 
				stripe_charge_id: charge.id,
				status: Payment.statuses['charged']
				)
		end

		def create_stripe_charge
			Stripe::Charge.create(
				customer: @stripe_customer.id,
				amount:  JOB_POSTING_FEE * 100,
				currency: 'usd',
				description: "Paid by #{employer.email}-#{employer.company} for job #{@job.id}"
				)
		end
	end
end