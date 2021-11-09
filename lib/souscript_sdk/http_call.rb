require "net/http"
require "active_support/core_ext/hash"

class SouscriptSDK
  module HTTPCall
    def query(method:, args:, http_method: :get)
      res =
        case http_method.to_sym
        when :get
          Net::HTTP.get(URI.parse(make_uri(args, base_params(method))))
        when :post
          Net::HTTP
            .post_form(
              URI.parse(@base_url),
              post_params(args, base_params(method))
            ).body
        else
          raise "HTTP method not handled : #{http_method}"
        end

      underscore_hash_keys(
        Hash.from_xml(
          res
            .force_encoding("ISO-8859-1")
            .encode("UTF-8")
            .gsub(/<(?=[^<>]*<)/, "&lt;")
            .gsub(/&(?!(?:amp|lt|gt|quot|apos);)/, "&amp;")
        )
      )
    end

    private

    def base_params(method)
      {
        ID: @user_name,
        PWD: @password,
        IDREQ: method
      }
    end

    def make_uri(args, params)
      uri = @base_url
      uri += "?#{params.map { |k, v| "#{k}=#{v}" }.join("&")}"

      args.each do |key, val|
        uri += "&#{key.upcase}=#{URI.encode_www_form_component(val)}"
      end

      uri
    end

    def post_params(args, params)
      params.merge(args.transform_keys(&:upcase))
    end
  end
end
