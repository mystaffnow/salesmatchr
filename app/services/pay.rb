module Services
	class Pay
		attr_accessor :employer, :job, :stripe_card_token

		def initialize(employer, job=nil, stripe_card_token=nil)
			@employer = employer
			@job = job
			@stripe_card_token = stripe_card_token
		end

		# return true if customer is saved to corressponding table otherwise false
		def is_customer_saved?
			result = false

			stripe_customer = create_stripe_customer
			return result if stripe_customer.nil?

			stripe_card_info = get_stripe_card_token_info(@stripe_card_token)
			return result if stripe_card_info.nil?

			customer = Customer.create(
				employer_id: @employer.id,
				stripe_card_token: @stripe_card_token,
				stripe_customer_id: stripe_customer.id,
				last4: stripe_card_info.last4,
				card_holder_name: stripe_card_info.name,
				exp_month: stripe_card_info.exp_month,
				exp_year: stripe_card_info.exp_year
				)
			return result if customer.errors.any?

			result = true # if customer.present?
			return result

			rescue => e
				Rails.logger.warn e.message
				return false
		end

		# when expired jobs are to make enable then system need to deduct predefined amount
		# from customer's card
		def is_payment_processed?(customer)
			result = false
			
			# these values required
			return result if (customer.nil? || employer.nil? || job.nil?)

			# Additional check: do not process request if empoyer did not have verified
			# payment information
			# binding.pry
			# customer = employer.customer

			return result unless is_customer_info_verified?(customer)
			
			stripe_customer_id = customer.stripe_customer_id

			# connect to stripe and charge from card
			stripe_charge = create_stripe_charge(stripe_customer_id)

			return result if stripe_charge.nil?

			# if stripe has deducted amount from card then save some information to our database
			payment = Payment.create(
				amount: stripe_charge.amount / 100,
				employer_id: employer.id,
				job_id: job.id,
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
		# def get_card_last4(stripe_token)
		#  	tok = Stripe::Token.retrieve(stripe_token)
		# 	tok.card.last4
		# end

		private
		# this method is used when employer open add payment details form to verify payment
		# details
		def create_stripe_customer
			return nil if stripe_card_token.nil?
			
			stripe_customer = Stripe::Customer.create(card: stripe_card_token)

			# while creating customer there is error response from stripe e.g: invalid token
			rescue => e
				Rails.logger.warn e.message
				return nil
		end


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
				# payment will not happen if stripe charge is not processed due to invalid
				# customer id, invalid currency or any other server side error
				Rails.logger.warn e.message
				return nil
		end

		# verify that stripe card token and stripe customer id exist
		def is_customer_info_verified?(customer)
			customer.stripe_card_token.present? || customer.stripe_customer_id.present?
		end

		# Get card info
		def get_stripe_card_token_info(stripe_token)
		 	tok = Stripe::Token.retrieve(stripe_token)
			tok.card

			rescue => e
				Rails.logger.warn e.message
				return nil
		end
	end
end