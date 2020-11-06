require "net/http"
require "active_support/core_ext/hash"

module SouscriptSDK
  module HTTPCall
    def query(method:, args:)
      uri = URI.parse(make_uri(method, args))
      res = Net::HTTP.get(uri)
      Hash.from_xml(res)
    end

    private

    def make_uri(method, args)
      uri = @base_url
      uri += "?ID=#{@user_name}&PWD=#{@password}"
      uri += "&IDREQ=#{method}"

      args.each do |key, val|
        uri += "&#{key.upcase}=#{val}"
      end

      uri
    end
  end
end
