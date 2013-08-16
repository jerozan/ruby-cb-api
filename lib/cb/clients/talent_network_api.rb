module Cb
	class TalentNetworkApi
		####################################################
		## Documentation:
		## http://api.careerbuilder.com/TalentNetwork.aspx
		####################################################

		def self.join_form_questions(tndid)
			## Load the join form questions for a TalentNetworkDID
			my_api = Cb::Utils::Api.new()
			cb_response = my_api.cb_get("#{Cb.configuration.uri_tn_join_questions}/#{tndid}/json")
			json_hash = JSON.parse(cb_response.response.body)

			tn_questions_collection = TalentNetwork.new(json_hash)
			my_api.append_api_responses(tn_questions_collection, json_hash)

			return tn_questions_collection
		end

		def self.join_form_branding(tndid)
			## Gets branding information (stylesheets, copytext, etc...) for the join form.
			my_api = Cb::Utils::Api.new
			cb_response = my_api.cb_get("#{Cb.configuration.uri_tn_join_form_branding}/#{tndid}")
			json_hash = JSON.parse(cb_response.response.body)
		end

		def self.join_form_geography(tnlanguage="USEnglish")
			## Gets locations needed to fill the Geography question from the Join Form Question API
			my_api = Cb::Utils::Api.new
			cb_response = my_api.cb_get("#{Cb.configuration.uri_tn_join_form_geo}", :query=>{:TNLanguage=>"#{tnlanguage}"})
			json_hash = JSON.parse(cb_response.response.body)
		end

		def self.member_create
			## Creates a member based on the form built with the Join Form Questions API call
		end

		def self.tn_job_information(job_did, join_form_intercept="true")
			my_api = Cb::Utils::Api.new
			cb_response = my_api.cb_get("#{Cb.configuration.uri_tn_job_info}/#{job_did}/json", :query=> {
				 :RequestJoinFormIntercept=>join_form_intercept})
			json_hash = JSON.parse(cb_response.response.body)
		
			tn_job_info = TalentNetwork::JobInfo.new(json_hash['Response'])
			my_api.append_api_responses(tn_job_info, json_hash)
			
			return tn_job_info
		
		end
	end #TalentNetworkJoinQuestions
end #module