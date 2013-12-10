module Cb
  module Responses
    module User

      class CheckExisting < ApiResponse

        protected

        def validate_api_hash
          required_response_field(root_node, response)
          required_response_field(user_check_status, response[root_node])
        end

        def extract_models
          response[root_node][user_check_status]
        end

        def metadata_containing_node
          response[root_node]
        end

        private

        def root_node
          @root_node ||= 'ResponseUserCheck'
        end

        def user_check_status
          @user_check_status ||= 'UserCheckStatus'
        end

      end

    end
  end
end
