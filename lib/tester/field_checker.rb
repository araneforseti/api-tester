class FieldChecker

  def is_field_in_hash field, hash
    if hash.empty? || hash.class.to_s != "Hash"
      return false
    end

    if hash.has_key?(field.name)
      if !field.has_subfields?
        return true
      end

      if field.has_subfields?
        if !check_based_on_type(field, hash)
          return false
        end
      end
      return true
    end
    false
  end

  def check_object_subfields field, field_hash
    field.fields.each do |subfield|
      if !is_in_hash(subfield, field_hash[field.name])
        return false
      end
    end
    true
  end

  def check_array_subfields field, field_hash
    field.fields.each do |subfield|
      if !is_in_hash(subfield, field_hash[field.name][0])
        return false
      end
    end
    true
  end

  def is_in_hash(field, field_hash)
    if field_hash.class.to_s != "Hash" || field_hash.empty?
      return false
    end

    if field_hash.has_key?(field.name)
      if !field.has_subfields?
        return true
      else
        return true
      end
    end
    false
  end

  def check_based_on_type field, field_hash
    field.is_a?(ObjectField) ? check_object_subfields(field, field_hash) : check_array_subfields(field, field_hash)
  end
end