module Services
	class Pay
		attr_accessor :employer, :job, :stripe_card_token

		def initialize(employer, job=nil, stripe_card_token=nil)
			@employer = employer
			@job = job
			@stripe_card_token = stripe_card_token
		end

		# this method is used when employer open add payment details form to verify payment details
		def create_stripe_customer
			return nil if stripe_card_token.nil?
			
			stripe_customer = Stripe::Customer.create(card: stripe_card_token)

			# while creating customer there is error response from stripe e.g: invalid token, etc
			rescue => e
				Rails.logger.warn e.message
				return nil
		end

		# when expired jobs are to make enable then system need to deduct predefined amount from customer's card
		def payment_processed?
			result = false
			
			# these values required
			return result if (employer.nil? || job.nil?)

			# Additional check: do not process request if empoyer did not have verified payment information
			customer = employer.customer
			return result if customer.nil?

			return result unless customer_info_verified?(customer)
			
			stripe_customer_id = customer.stripe_customer_id

			# connect to stripe and charge from card
			stripe_charge = create_stripe_charge(stripe_customer_id)

			return result if stripe_charge.nil?

			# if stripe has deducted amount from card then save some information to our database
			payment = Payment.create(
				amount: stripe_charge.amount / 100,
				employer_id: employer.id,
				job_id: job.id,
				stripe_customer_id: stripe_customer_id, 
				stripe_charge_id: stripe_charge.id,
				status: Payment.statuses['charged'],
				customer_id: customer.id
				)
			result = true if payment.present?
			return result

			rescue => e
				Rails.logger.warn e.message
				return false
		end

		# get card last4 digit
		def get_card_last4(stripe_token)
		 	tok = Stripe::Token.retrieve(stripe_token)
			tok.card.last4
		end

		private

		# stripe will deduct amount as per requested data
		def create_stripe_charge(stripe_customer_id)
			charge = Stripe::Charge.create(
				customer: "#{stripe_customer_id}",
				amount:  JOB_POSTING_FEE.to_i * 100,
				currency: 'usd',
				description: "Paid by #{employer.email}-#{employer.company} for job #{@job.id}"
				)
			return charge

			rescue => e
				# payment will not happen if stripe charge is not processed due to invalid customer id, invalid currency or any other server side error
				Rails.logger.warn e.message
				return nil
		end

		# verify that stripe card token and stripe customer id exist
		def customer_info_verified?(customer)
			customer.stripe_card_token.present? || customer.stripe_customer_id.present?
		end
	end
end