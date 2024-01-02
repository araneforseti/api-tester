# frozen_string_literal: true

module ApiTester
  # Class for defining expected responses
  class Response
    attr_accessor :code, :body

    def initialize(status_code: 200)
      self.code = status_code
      self.body = []
    end

    def add_field(new_field)
      body << new_field
      self
    end

    def add_array_field(&block)
      field = ApiTester::ArrayField.new(name: '', has_key: false)
      field.instance_eval(&block)
      add_field(field)
    end

    def to_s
      des = {}
      body.map do |f|
        if f.has_key
          des[f.name] = field_display f
        else
          des = field_display f
        end
      end
      des.to_json
    end

    def field_display(field)
      des = field.display_class
      if field.subfields?
        des = {}
        field.fields.map do |f|
          if f.has_key
            des[f.name] = field_display f
          else
            des = field_display f
          end
        end
        des.to_json
      end
      des
    end
  end
end
