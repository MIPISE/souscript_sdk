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

    define_request(:scpis, 1001) { |response| response.dig(:api, :scpi) }

    define_request(:scpi_valuation, 1002, %i[idscpi]) { |response| response.dig(:api, :valeur) }
  end
end
