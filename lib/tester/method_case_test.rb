require 'tester/util/response_evaluator.rb'

class MethodCaseTest
    attr_accessor :method
    attr_accessor :payload
    attr_accessor :response
    attr_accessor :reports
    attr_accessor :url

    def initialize(method, payload)
        self.method = method
        self.payload = payload
        self.response = method.call payload, method.request.default_headers
        self.reports = []
        self.url = "#{method.verb} #{method.url}"
    end
    
    def response_code_report
        report = StatusCodeReport.new "Incorrect response code", self.url, self.payload, self.method.expected_response.code, self.response.code
        self.reports << report
    end
  
      def missing_field_report field
          report = Report.new "Missing field #{field}", self.url, self.payload, self.method.expected_response, self.response
          self.reports << report
      end
  
      def extra_field_report field
          report = Report.new "Found extra field #{field}", self.url, self.payload, self.method.expected_response, self.response
          self.reports << report
      end
  
      def check
          if check_response_code
              evaluator = ResponseEvaluator.new json_parse(self.response.body), self.method.expected_response
              evaluator.missing_fields.map{|field| missing_field_report(field)}
              evaluator.extra_fields.map{|field| extra_field_report(field)}
              increment_fields evaluator.seen_fields
          end
          return self.reports
      end
  
      def check_response_code
          if response.code != method.expected_response.code
              self.reports << response_code_report
              return false
          end
          return true
      end
  
      def increment_fields seen_fields
          seen_fields.each do |field|
              field.seen
          end
      end
  
      def json_parse body
          JSON.parse!(body)
        rescue JSON::ParserError
          body
      end
end
