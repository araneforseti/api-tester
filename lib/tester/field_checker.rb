class FieldChecker
  def is_field_in_hash field, hash
    if hash.empty?
      puts "Missing #{field.name}"
      return false
    end

    if hash.has_key?(field.name)
      if !field.has_subfields?
        return true
      end

      if field.has_subfields?
        field.fields.each do |subfield|
          if !is_field_in_hash(subfield, hash[field.name])
            puts "Missing #{field.name}.#{subfield.name}"
            return false
          end
        end
      end
      return true
    end
    false
  end
end