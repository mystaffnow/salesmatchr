require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
	let(:candidate) {create(:candidate)}
	let(:job) {create(:job)}

	it '#get_archetype_from_score' do
		expect(helper.get_archetype_from_score(nil)).to eq('n/a')
		expect(helper.get_archetype_from_score(72)).to eq('Aggressive Hunter')
		expect(helper.get_archetype_from_score(32)).to eq('Relaxed Hunter')
		expect(helper.get_archetype_from_score(12)).to eq('Aggressive Fisherman')
		expect(helper.get_archetype_from_score(-9)).to eq('Balanced Fisherman')
		expect(helper.get_archetype_from_score(-29)).to eq('Relaxed Fisherman')
		expect(helper.get_archetype_from_score(-69)).to eq('Aggressive Farmer')
		expect(helper.get_archetype_from_score(-71)).to eq('Relaxed Farmer')
	end

	it '#get_archetype_image_from_score' do
		expect(helper.get_archetype_image_from_score(nil)).to eq('rocket.png')
		expect(helper.get_archetype_image_from_score(72)).to eq('aggressive-hunter.jpeg')
		expect(helper.get_archetype_image_from_score(32)).to eq('relaxed-hunter.jpeg')
		expect(helper.get_archetype_image_from_score(12)).to eq('aggressive-fisherman.jpeg')
		expect(helper.get_archetype_image_from_score(-9)).to eq('balanced-fisherman.jpeg')
		expect(helper.get_archetype_image_from_score(-29)).to eq('relaxed-fisherman.jpeg')
		expect(helper.get_archetype_image_from_score(-69)).to eq('aggressive-farmer.jpeg')
		expect(helper.get_archetype_image_from_score(-71)).to eq('relaxed-farmer.jpeg')
	end

	it '#get_archetype_description_from_score' do
		expect(helper.get_archetype_description_from_score(nil)).to eq('n/a')
		expect(helper.get_archetype_description_from_score(72)).to eq('Your SalesMatchr™ assessment shows that you are an Aggressive Hunter. <br/>An Aggressive Hunter is constantly burning through tasks and objectives, but sometimes he fails to think through all the details. Aggressive Hunters are CLOSERS, inside or outside - enough said!')
		expect(helper.get_archetype_description_from_score(32)).to eq('Your SalesMatchr™ assessment shows that you are a Relaxed Hunter. <br/>A Relaxed Hunter quickly completes tasks and objectives and is collaborative in nature and thrives in both sales "hunting" and Account Management roles, but can fall short with the little details since they are more hungry for the thrill of the hunt!')
		expect(helper.get_archetype_description_from_score(12)).to eq('Your SalesMatchr™ assessment shows that you are an Aggressive Fisherman. <br/>An Aggressive Fisherman likes to tackle objectives head on, but is willing to sit down and think things through before throwing a wide net to catch new Leads.')
		expect(helper.get_archetype_description_from_score(-9)).to eq('Your SalesMatchr™ assessment shows that you are a Balanced Fisherman. <br/>A Balanced Fisherman likes to spend some time planning and strategizing, and then efficiently carries out the work at hand.')
		expect(helper.get_archetype_description_from_score(-29)).to eq('Your SalesMatchr™ assessment shows that you are a Relaxed Fisherman. <br/>A Relaxed Fisherman likes to sit down and think things through, but is not afraid to work fast when needed.  You thrive in business development type rolls where building long term relationships is crucial.')
		expect(helper.get_archetype_description_from_score(-69)).to eq("Your SalesMatchr™ assessment shows that you are an Aggressive Farmer. <br/>An Aggressive Farmer strengths lie in developing and maintaining relationships with customers.  You earn your Customer's trust by making sure all the details are handled well and that they're happy!")
		expect(helper.get_archetype_description_from_score(-71)).to eq('Your SalesMatchr™ assessment shows that you are a Relaxed Farmer. <br/>A Relaxed Farmer works slowly and carefully, putting plenty of thought into every decision.  You thrive in account management and business development positions and have great relationships')
	end

	it '#format_date' do
		date = 'Mon, 06 Mar 2017'
		expect(helper.format_date(date.to_date)).to eq('March 2017')
		expect(helper.format_date(nil)).to eq(nil)
		expect{helper.format_date("")}.to raise_error("undefined method `strftime' for \"\":String")
	end

	it '#format_date_time' do
		date_time = '2017-03-06 15:10:11 +0545'
		expect(helper.format_date_time(date_time.to_time)).to eq(" 03:10pm")
		expect{helper.format_date_time(nil)}.to raise_error("undefined method `strftime' for nil:NilClass")
		expect{helper.format_date_time("")}.to raise_error("undefined method `strftime' for \"\":String")
	end

	it '#format_time' do
		time = '2017-03-06 15:20:42 +0545'
		expect(helper.format_time(time.to_time)).to eq('03:20pm')
		expect{helper.format_time(nil)}.to raise_error("undefined method `strftime' for nil:NilClass")
		expect{helper.format_time("")}.to raise_error("undefined method `strftime' for \"\":String")
	end

	it '#get_location' do
		candidate = create(:candidate)
		state = create(:state)

		# when profile info like city state are nil
		expect(helper.get_location(CandidateProfile.first)).to eq(nil)
		
		candidate_profile = CandidateProfile.first.update(city: 'test city', state_id: state.id, zip: 1020)
		# when profile info are present
		expect(helper.get_location(CandidateProfile.first)).to eq("test city Alaska, 1020")
	
		expect{helper.get_location(nil)}.to raise_error("undefined method `state' for nil:NilClass")
	end

	it '#get_status_key_by_value' do
		expect{helper.get_status_key_by_value(nil)}.to raise_error("no implicit conversion from nil to integer")
		expect(helper.get_status_key_by_value(0)).to eq("submitted")
	end

	context '#job_candidate_saved?' do
		let(:function) {
			@candidate = candidate
			@job = job
		}

		it 'when rec found with true' do
			function
		  CandidateJobAction.create(candidate_id: @candidate.id, job_id: @job.id, is_saved: true)
		  expect(helper.job_candidate_saved?(@candidate.id, @job.id)).to eq(true)
		end

		it 'when rec found with false' do
			function
		  CandidateJobAction.create(candidate_id: @candidate.id, job_id: @job.id, is_saved: false)
		  expect(helper.job_candidate_saved?(@candidate.id, @job.id)).to eq(false)
		end

		it 'when rec not found' do
		  expect(helper.job_candidate_saved?(nil, nil)).to eq(false)
	  end
	end

	context '#list_job_viewed_by_visible_candidates' do
		it 'should return candidate_job_actions record' do
			@job = job
			@candidate1 = candidate
			CandidateProfile.first.update(is_incognito: true)
			@candidate2 = create(:candidate)
			CandidateProfile.second.update(is_incognito: false)
			@candidate3 = create(:candidate)
			CandidateProfile.third.update(is_incognito: false)
			@candidate4 = create(:candidate)
			CandidateProfile.fourth.update(is_incognito: false)
			@candidate5 = create(:candidate)
			CandidateProfile.fifth.update(is_incognito: true)

			@cja1 = create(:candidate_job_action, candidate_id: @candidate1.id, job_id: @job.id, is_saved: false)
			@cja2 = create(:candidate_job_action, candidate_id: @candidate2.id, job_id: @job.id, is_saved: false)
			@cja3 = create(:candidate_job_action, candidate_id: @candidate3.id, job_id: @job.id, is_saved: false)
			@cja4 = create(:candidate_job_action, candidate_id: @candidate4.id, job_id: @job.id, is_saved: false)
			@cja5 = create(:candidate_job_action, candidate_id: @candidate5.id, job_id: @job.id, is_saved: false)
		  
		  expect(helper.list_job_viewed_by_visible_candidates(@job)).to eq([@cja2, @cja3, @cja4])
		end

		it 'should return empty array' do
			@job = job
			@candidate1 = candidate
			CandidateProfile.first.update(is_incognito: true)

		  expect(helper.list_job_viewed_by_visible_candidates(@job)).to eq([])
		  expect(helper.list_job_viewed_by_visible_candidates(nil)).to eq([])
		end
	end

	it '#submitted_payment_details' do
		state = create(:state, name: 'title 1')
		employer = create(:employer)
	  employer1 = create(:employer)
	  job_function = create(:job_function, name: 'title 1')
	  job1 = create(:job, employer_id: employer.id, salary_low: 45000, salary_high: 280000, zip: "10900", 
	                   city: 'city1', state_id: state.id,job_function_id: job_function.id, is_active: true, status: Job.statuses["enable"])
	  stripe_card_token = generate_stripe_card_token

		pay_service = Services::Pay.new(employer, job, stripe_card_token)
    stripe_cus = pay_service.create_stripe_customer
    create(:customer, employer_id: employer.id,
                      stripe_customer_id: stripe_cus.id,
                      stripe_card_token: stripe_card_token)
  	expect(Customer.count).to eq(1)
  	expect(helper.submitted_payment_details?(employer)).to be_truthy
  	expect(helper.submitted_payment_details?(employer1)).to be_falsy
	end
end