require 'tester/definition/methods/api_copy'
require 'tester/definition/methods/api_delete'
require 'tester/definition/methods/api_get'
require 'tester/definition/methods/api_head'
require 'tester/definition/methods/api_lock'
require 'tester/definition/methods/api_mkcol'
require 'tester/definition/methods/api_move'
require 'tester/definition/methods/api_options'
require 'tester/definition/methods/api_patch'
require 'tester/definition/methods/api_post'
require 'tester/definition/methods/api_propfind'
require 'tester/definition/methods/api_proppatch'
require 'tester/definition/methods/api_put'
require 'tester/definition/methods/api_trace'
require 'tester/definition/methods/api_unlock'

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
    {
      :copy => ApiCopy,
      :delete => ApiDelete,
      :get => ApiGet,
      :head => ApiHead,
      :lock => ApiLock,
      :mkcol => ApiMkcol,
      :move => ApiMove,
      :options => ApiOptions,
      :patch => ApiPatch,
      :post => ApiPost,
      :propfind => ApiPropfind,
      :proppatch => ApiProppatch,
      :put => ApiPut,
      :unlock => ApiUnlock,
      :trace => ApiTrace
    }[verb]
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
