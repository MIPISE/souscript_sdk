require "byebug"

module SouscriptSDK
  module Request
    def self.define_request(method, code, mandatory_args = {}, optional_args = {}, &process)
      define_method(method) do |args = {}|
        res = query(method: code, args: args)
        process.call(res)
      end
    end

    define_request(:scpis, 1001) { |response| response.dig("API", "SCPI") }

    define_request(:scpi_valuation, 1002, %i[idscpi]) { |response| response.dig("API", "VALEUR") }
  end
end
