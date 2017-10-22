class Response
    attr_accessor :code
    attr_accessor :body

    def initialize(status_code)
        self.code = status_code
        self.body = []
    end

    def add_field(new_field)
        self.body << new_field
        self
    end

    def to_s
        s = self.body.map{|f| "#{f.name}:#{f.class}" }
        s.to_s
    end
end
