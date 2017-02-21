module Services
	class Pay
		attr_accessor :employer, :job, :stripe_card_token

		def initialize(employer, job, stripe_card_token)
			@employer = employer
			@job = job
			@stripe_card_token = stripe_card_token

			@stripe_customer = Stripe::Customer.create(card: stripe_card_token)
		end

		def process_payment
			charge = create_stripe_charge

			return nil if charge.nil?
			
			payment = Payment.create(
				amount: charge.amount / 100,
				employer_id: employer.id,
				job_id: job.id,
				stripe_card_token: stripe_card_token, 
				stripe_customer_id: @stripe_customer.id, 
				stripe_charge_id: charge.id,
				status: Payment.statuses['charged']
				)
			rescue => e
				Rails.logger.warn e.message
				return nil
		end

		def create_stripe_charge
			charge = Stripe::Charge.create(
				customer: @stripe_customer.id,
				amount:  JOB_POSTING_FEE.to_i * 100,
				currency: 'usd',
				description: "Paid by #{employer.email}-#{employer.company} for job #{@job.id}"
				)
			return charge
			rescue => e
				Rails.logger.warn e.message
				return nil
		end
	end
end