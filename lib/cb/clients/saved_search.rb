module Cb
  module Clients

    class SavedSearch
      def create(saved_search)
        body = saved_search.create_to_xml
        json = cb_client.cb_post(Cb.configuration.uri_saved_search_create, body: body)
        singular_model_response(json, saved_search.external_user_id)
      end

      def update(saved_search)
        body = saved_search.update_to_json
        json = cb_client.cb_put(Cb.configuration.uri_saved_search_update, body: body, headers: headers)
        Responses::SavedSearch::Update.new(json)
      end

      def delete(hash)
        uri = replace_uri_field(Cb.configuration.uri_saved_search_delete, ':did', hash[:did])
        json = cb_client.cb_delete(
          uri,
          {
            headers: { 'HostSite' => hash[:host_site] },
            query: { "UserOAuthToken" =>hash[:user_oauth_token] }
          }
        )
        Responses::SavedSearch::Delete.new(json)
      end

      def retrieve(oauth_token, external_id)
        query = retrieve_query(oauth_token)
        uri = replace_uri_field(Cb.configuration.uri_saved_search_retrieve, ':did', external_id)
        json = cb_client.cb_get(uri, query: query)
        Responses::SavedSearch::Retrieve.new(json)
      end

      def list(oauth_token, hostsite)
        query = list_query(oauth_token, hostsite)
        json = cb_client.cb_get(Cb.configuration.uri_saved_search_list, query: query)
        Responses::SavedSearch::List.new(json)
      end

      private

      def headers
        {
            "developerkey" => Cb.configuration.dev_key,
            'Content-Type' => "application/json"
        }
      end

      def cb_client
        @cb_client ||= Cb::Utils::Api.instance
      end

      def retrieve_query(oauth_token)
        {
            :developerkey   => Cb.configuration.dev_key,
            :useroauthtoken => oauth_token
        }
      end

      def list_query(oauth_token, hostsite)
        {
            :developerkey   => Cb.configuration.dev_key,
            :useroauthtoken => oauth_token,
            :hostsite => hostsite
        }
      end

      def singular_model_response(json_hash, external_user_id = nil, external_id = nil)
        json_hash['ExternalUserID'] = external_user_id unless external_user_id.nil?
        json_hash['ExternalID'] = external_id unless external_id.nil?
        Responses::SavedSearch::Singular.new(json_hash)
      end

      def replace_uri_field(uri_string, field, replacement)
        uri_string.gsub(field, replacement)
      end
    end

  end
end
