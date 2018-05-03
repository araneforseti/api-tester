class SupportedVerbs
  def SupportedVerbs.add_item(key, value)
    @hash ||= {}
    @hash[key] = value
  end

  def SupportedVerbs.const_missing(key)
    @hash[key]
  end

  def SupportedVerbs.each
    @hash.each {|key,value| yield(key,value)}
  end

  def SupportedVerbs.all
    @hash.values
  end

  def SupportedVerbs.get_method_for(verb)
    {:get => ApiGet, :post => ApiPost}[verb]
  end

  SupportedVerbs.add_item :GET, :get
  SupportedVerbs.add_item :POST, :post
end
