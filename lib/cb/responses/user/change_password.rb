module Cb
  module Responses
    module User

      class ChangePassword < ApiResponse
        class Model < Struct.new(:status) ; end

        protected

        def validate_api_hash
          required_response_field(root_node, response)
          required_response_field(request_node, response[root_node])
        end

        def extract_models
          model = Model.new()
          model.status = response[root_node][status_node]
          model
        end

        def hash_containing_metadata
          response
        end

        private

        def root_node
          'ResponseUserChangePW'
        end

        def request_node
          'Request'
        end

        def status_node
          'Status'
        end
      end

    end
  end
end
