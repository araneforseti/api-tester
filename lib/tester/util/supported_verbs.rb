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
    {:get => ApiGet, :post => ApiPost, :delete => ApiDelete, :put => ApiPut,
      :patch => ApiPatch, :head => ApiHead, :options => ApiOptions, :copy => ApiCopy,
      :lock => ApiLock, :unlock => ApiUnlock}[verb]
  end

  SupportedVerbs.add_item :GET, :get
  SupportedVerbs.add_item :POST, :post
  SupportedVerbs.add_item :DELETE, :delete
  SupportedVerbs.add_item :PUT, :put
  SupportedVerbs.add_item :PATCH, :patch
  SupportedVerbs.add_item :HEAD, :head
  SupportedVerbs.add_item :OPTIONS, :options
  SupportedVerbs.add_item :COPY, :copy
  # SupportedVerbs.add_item :LINK, :link
  # SupportedVerbs.add_item :UNLINK, :unlink
  # SupportedVerbs.add_item :PURGE, :purge
  SupportedVerbs.add_item :LOCK, :lock
  SupportedVerbs.add_item :UNLOCK, :unlock
  # SupportedVerbs.add_item :PROPFIND, :propfind
  # SupportedVerbs.add_item :PROPPATCH, :proppatch
  # SupportedVerbs.add_item :VIEW, :view
  # SupportedVerbs.add_item :MKCOL, :mkcol
  # SupportedVerbs.add_item :CONNECT, :connect
  # SupportedVerbs.add_item :TRACE, :trace
  # SupportedVerbs.add_item :MOVE, :move
end
