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
        s = self.body.map do |f|
            field_display f
        end
        s.to_s
    end

    def field_display field
        if field.has_subfields?
            "#{field.name}:#{field.fields.map{|f| field_display(f)}}"
        else
            "#{field.name}:#{field.display_class}"
        end
    end
end
