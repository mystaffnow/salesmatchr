def employer_profile(employer)
  employer_profile = EmployerProfile.where(employer_id: employer.id).try(:first)
  employer_profile.update_attributes(city: 'test city', zip: 10200, state_id: state.id, website: 'www.test.example.com')
  employer_profile
end

def candidate_profile(candidate)
	candidate_profile = CandidateProfile.where(candidate_id: candidate.id).try(:first)
	candidate_profile.update_attributes(avatar: path, state_id: state.id, city: 'Wichita', zip: '1020', is_incognito: false, education_level_id: education_level.id)
	candidate_profile
end