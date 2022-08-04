require 'api-tester'

ApiTester.contract do |contract|
  contract.base_url = "https://gorest.co.in/"
  contract.required_headers = {
    'Content-Type' => 'application/json',
    'Authorization' => "Bearer #{ENV.fetch('AUTH_TOKEN')}"
  }
  contract.add_not_found_response do |response|
    response.code = 404
  end
  contract.add_bad_request_response do |response|
    response.code = 422
  end
  
  contract.add_endpoint do |endpoint|
    endpoint.relative_url = "users"

    endpoint.add_request do |request|
      request.verb = "get"
      request.add_query IdField.new name: 'id'
      request.add_query NameField.new name: 'name'
      request.add_query EmailField.new name: 'email'
      request.add_field EnumField.new name: 'gender', values: ['male', 'female']
      request.add_field EnumField.new name: 'status', values: ['active', 'inactive']

      request.response do |response|
        response.code = 200

        response.add_array_field do |field|
          field.name = 'users'
          field.has_key = false
          field.add_field IdField.new name: 'id', required: true
          field.add_field NameField.new name: 'name', required: true
          field.add_field EmailField.new name: 'email', required: true
          field.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
          field.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
        end
      end
    end

    endpoint.add_request do |request|
      request.verb = "post"
      request.add_field NameField.new name: 'name', required: true
      request.add_field EmailField.new name: 'email', required: true
      request.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
      request.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
      request.response do |response|
        response.code = 201
        response.add_field IdField.new name: 'id', required: true
        response.add_field NameField.new name: 'name', required: true
        response.add_field EmailField.new name: 'email', required: true
        response.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
        response.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
      end
    end
  end

  contract.add_endpoint do |endpoint|
    endpoint.relative_url = "users/{id}"
    endpoint.test_helper = UserCreator.new contract.base_url
    endpoint.add_path_param 'id'
    endpoint.add_default_response do |response|
      response.code = 200
      response.add_field IdField.new name: 'id', required: true
      response.add_field NameField.new name: 'name', required: true
      response.add_field EmailField.new name: 'email', required: true
      response.add_field EnumField.new name: 'gender', values: ['male', 'female'], required: true
      response.add_field EnumField.new name: 'status', values: ['active', 'inactive'], required: true
    end

    endpoint.add_request do |request|
      request.verb = "get"
    end

    endpoint.add_request do |request|
      request.verb = "delete"
      request.response do |response|
        response.code = 200
        response.body = nil
      end
    end

    endpoint.add_request do |request|
      request.verb = "patch"
      request.add_field NameField.new name: 'name'
      request.add_field EmailField.new name: 'email'
      request.add_field EnumField.new name: 'gender', values: ['male', 'female']
      request.add_field EnumField.new name: 'status', values: ['active', 'inactive']
    end

    endpoint.add_request do |request|
      request.verb = "put"
      request.add_field NameField.new name: 'name'
      request.add_field EmailField.new name: 'email'
      request.add_field EnumField.new name: 'gender', values: ['male', 'female']
      request.add_field EnumField.new name: 'status', values: ['active', 'inactive']
    end
  end
end
