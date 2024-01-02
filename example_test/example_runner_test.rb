require 'api-tester'

ApiTester.enable_tester(ApiTester::Testers::GoodCase)

ApiTester.contract('Go Rest', 'https://gorest.co.in/public/v2/') do |contract|
  contract.required_headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{ENV.fetch('AUTH_TOKEN')}"
  }
  contract.not_found_response = ApiTester::Response.new(status_code: 404)
  contract.bad_request_response = ApiTester::Response.new(status_code: 422)

  contract.with_endpoint do |endpoint|
    endpoint.relative_url = 'users'
    
    endpoint.add_method do |method|
      method.verb = "get"

      method.add_request do |request|
        request.add_query_param ApiTester::Field.new name: 'id'
        request.add_query_param ApiTester::Field.new name: 'name'
        request.add_query_param ApiTester::EmailField.new name: 'email'
        request.add_field ApiTester::EnumField.new name: 'gender', values: ['male', 'female']
        request.add_field ApiTester::EnumField.new name: 'status', values: ['active', 'inactive']
      end

      method.add_response do |response|
        response.code = 200

        response.add_array_field do |field|
          field.name = 'users'
          field.has_key = false
          field.with_field ApiTester::Field.new name: 'id', required: true
          field.with_field ApiTester::Field.new name: 'name', required: true
          field.with_field ApiTester::EmailField.new name: 'email', required: true
          field.with_field ApiTester::EnumField.new name: 'gender', values: ['male', 'female'], required: true
          field.with_field ApiTester::EnumField.new name: 'status', values: ['active', 'inactive'], required: true
        end
      end
    end

    #    endpoint.add_request do |request|
    #      request.verb = "post"
    #      request.add_field NameField.new name: 'name', required: true
    #      request.add_field EmailField.new name: 'email', required: true
    #      request.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
    #     request.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
    #      request.response do |response|
    #        response.code = 201
    #        response.add_field IdField.new name: 'id', required: true
    #        response.add_field NameField.new name: 'name', required: true
    #        response.add_field EmailField.new name: 'email', required: true
    #        response.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
    #        response.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
    #      end
    #   end
  end

  #  contract.add_endpoint do |endpoint|
  #    endpoint.relative_url = "users/{id}"
  #    endpoint.test_helper = UserCreator.new contract.base_url
  #    endpoint.add_path_param 'id'
  #    endpoint.add_default_response do |response|
  #      response.code = 200
  #      response.add_field IdField.new name: 'id', required: true
  #      response.add_field NameField.new name: 'name', required: true
  #      response.add_field EmailField.new name: 'email', required: true
  #      response.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
  #      response.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
  #    end

  #    endpoint.add_request do |request|
  #      request.verb = "get"
  #    end

  #    endpoint.add_request do |request|
  #      request.verb = "delete"
  #      request.response do |response|
  #        response.code = 200
  #        response.body = nil
  #      end
  #    end

  #    endpoint.add_request do |request|
  #      request.verb = "patch"
  #      request.add_field NameField.new name: 'name'
  #      request.add_field EmailField.new name: 'email'
  #      request.add_field EnumField.new name: 'gender', values: ['male', 'female']
  #      request.add_field EnumField.new name: 'status', values: ['active', 'inactive']
  #    end

  #    endpoint.add_request do |request|
  #      request.verb = "put"
  #      request.add_field NameField.new name: 'name'
  #      request.add_field EmailField.new name: 'email'
  #      request.add_field EnumField.new name: 'gender', values: ['male', 'female']
  #      request.add_field EnumField.new name: 'status', values: ['active', 'inactive']
  #    end
  #  end
end
