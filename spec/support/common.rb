def employer_profile(employer)
  # binding.pry
  #employer_profile = EmployerProfile.where(employer_id: employer.id).try(:first)
  create(:employer_profile, employer_id: employer.id, city: 'test city', zip: 10200,
                           state_id: state.id, website: 'www.test.example.com', description: 'General description')
  # employer_profile
end

def candidate_profile(candidate)
	candidate_profile = CandidateProfile.where(candidate_id: candidate.id).try(:first)
	candidate_profile.update_attributes(avatar: path, state_id: state.id, city: 'Wichita', zip: '1020', is_incognito: false, education_level_id: education_level.id)
	# candidate_profile
  # binding.pry
  # create(:candidate_profile, candidate_id: candidate.id, avatar: path,
  #         state_id: state.id, city: 'Wichita', zip: '1020', is_incognito: false,
  #         education_level_id: education_level.id)
end

def blank_profile(employer_profile)
  employer_profile.zip=nil
  employer_profile.state_id=nil
  employer_profile.city=nil
  employer_profile.website=nil
  employer_profile.description=nil
  employer_profile.save(validate: false)
end