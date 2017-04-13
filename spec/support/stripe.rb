# return stripe card token
def generate_stripe_card_token
	Stripe.api_key = "sk_test_4Bqn5DAx7IfmDeECYppLl1PY"
	result = Stripe::Token.create(
	  :card => {
	    :number => "4242424242424242",
	    :exp_month => 2,
	    :exp_year => 2018,
	    :cvc => "314"
	  },
	)
	result.id
end

# return stripe customer id
def generate_stripe_customer(stripe_card_token)
	Stripe.api_key = "sk_test_4Bqn5DAx7IfmDeECYppLl1PY"
	result = Stripe::Customer.create(card: stripe_card_token)
	result.id
end