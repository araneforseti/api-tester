module ApiTester
  class Response
      attr_accessor :code
      attr_accessor :body

      def initialize(status_code=200)
          self.code = status_code
          self.body = []
      end

      def add_field(new_field)
          self.body << new_field
          self
      end

      def to_s
          des = {}
          self.body.map do |f|
              des[f.name] = field_display f
          end
          des.to_json
      end

      def field_display field
          des = field.display_class
          if field.has_subfields?
            des = {}
            field.fields.map do |f|
              des[f.name] = field_display f
            end
            des.to_json
          end
          des
      end
  end
end
