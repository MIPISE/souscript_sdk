require "net/http"
require "active_support/core_ext/hash"

class SouscriptSDK
  module HTTPCall
    def query(method:, args:, http_method: :get)
      res =
        case http_method.to_sym
          when :get
            uri = URI.parse(make_uri(method, args))
            Net::HTTP
              .get(uri)
              .force_encoding("ISO-8859-1").encode("UTF-8") # Fix encoding issue with accentuated letters
          when :post
            Net::HTTP
              .post_form(URI.parse(@base_url), post_params(method, args))
              .body
              .force_encoding("ISO-8859-1").encode("UTF-8")
          else
            raise "http method not handled : #{http_method}"
        end
      underscore_hash_keys(
        Hash.from_xml(
          res
            .gsub(/<(?=[^<>]*<)/, "&lt;")
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
        uri += "&#{key.upcase}=#{URI.encode_www_form_component(val)}"
      end

      uri
    end

    def post_params(method, args)
      args.inject({'ID' => @user_name, 'PWD' => @password, 'IDREQ' => method}) do |memo, (key, val)|
        memo[key.upcase] = URI.encode_www_form_component(val)
        memo
      end
    end
  end
end
