require "net/http"
require "active_support/core_ext/hash"

class SouscriptSDK
  module HTTPCall
    def query(method:, args:)
      uri = URI.parse(URI.escape(make_uri(method, args)))
      res = Net::HTTP
        .get(uri)
        .force_encoding("ISO-8859-1").encode("UTF-8") # Fix encoding issue with accentuated letters

      underscore_hash_keys(
        Hash.from_xml(
          res
            .gsub(/<(?=[^<>]*<)/, '&lt;')
            .gsub(/&(?!(?:amp|lt|gt|quot|apos);)/, "&amp;")
        )
      )
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
