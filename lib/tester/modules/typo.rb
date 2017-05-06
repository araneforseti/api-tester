require 'tester/reporter/status_code_report'
require 'tester/modules/module'
require 'tester/util/supported_verbs'

class Typo < Module
  def go(definition, report)
    super

    contract = allowances(definition)

    contract.each do |url, verbs|
      check_verbs definition, url, verbs

      check_typo_url definition, url
    end

    report.reports == []
  end

  def check_verbs definition, url, verbs
    missing_verbs = SupportedVerbs.all - verbs
    missing_verbs.each do |verb|
      response = call url, verb
      request = Request.new
      response_matches response, request, definition.not_allowed_response, ApiMethod.new(url)
    end
  end

  def check_typo_url definition, url
    bad_url = "#{url}gibberishadsfasdf"
    request = Request.new
    response = call bad_url, SupportedVerbs::GET
    response_matches response, request, definition.not_found_response, ApiMethod.new(bad_url)
  end

  def allowances(definition)
    allowances = {}
    definition.methods.each do |method|
      url = method.url
      if allowances[url]
        allowances[url] << method.verb
      else
        allowances[url] = [method.verb]
      end
    end
    allowances
  end

  def call(url, verb)
    begin
      RestClient::Request.execute(method: verb, url: url,
                                timeout: 10)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end