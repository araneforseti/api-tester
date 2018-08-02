module ApiTester
  # Class defining the verbs this tool supports
  class SupportedVerbs
    def self.add_item(key, value)
      @hash ||= {}
      @hash[key] = value
    end

    def self.const_missing(key)
      @hash[key]
    end

    def self.each
      @hash.each { |key, value| yield(key, value) }
    end

    def self.all
      @hash.values
    end

    SupportedVerbs.add_item :COPY, :copy
    SupportedVerbs.add_item :DELETE, :delete
    SupportedVerbs.add_item :GET, :get
    SupportedVerbs.add_item :HEAD, :head
    SupportedVerbs.add_item :LOCK, :lock
    SupportedVerbs.add_item :MKCOL, :mkcol
    SupportedVerbs.add_item :MOVE, :move
    SupportedVerbs.add_item :OPTIONS, :options
    SupportedVerbs.add_item :PATCH, :patch
    SupportedVerbs.add_item :POST, :post
    SupportedVerbs.add_item :PROPFIND, :propfind
    SupportedVerbs.add_item :PROPPATCH, :proppatch
    SupportedVerbs.add_item :PUT, :put
    SupportedVerbs.add_item :TRACE, :trace
    SupportedVerbs.add_item :UNLOCK, :unlock
  end
end
