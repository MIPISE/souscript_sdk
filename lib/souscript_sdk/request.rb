require "byebug"

module SouscriptSDK
  module Request
    def self.define_request(method, code, required_keys = [], optional_keys = [], &process)
      define_method(method) do |args = {}|
        result =
          query(
            method: code,
            args: format_hash(args, required_keys, optional_keys)
          )

        process.call(result)
      end
    end

    # REQUETES TYPE 1000 ENVIRONNEMENT

    define_request(:scpis, 1001) { |response| response.dig(:api, :scpi) }

    define_request(:scpi_valuation, 1002, %i[idscpi]) { |response| response.dig(:api, :valeur) }

    define_request(:scpi_bare_ownerships, 1003, %i[idscpi]) { |response| response.dig(:api, :valeur) }

    define_request(:document_categories, 1004) { |response| response.dig(:api, :catdoc) }

    define_request(:document_types, 1005, %i[idcat]) { |response| response.dig(:api, :typedoc) }
  end
end
