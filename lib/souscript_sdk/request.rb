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

    # ========================================================================
    # > Requetes type 1000 environnement
    # ========================================================================

    # SCPI: liste des SCPI
    # ------------------------------------------------------------------------
    # @return: [SCPI]
    #   - :id  [String] ID de la SCPI
    #   - :nom [String] Nom de la SCPI
    define_request(:scpis, 1001) { |response| response.dig(:api, :scpi) }

    # Valorisation SCPI : liste des valeurs historiques de souscription
    # ------------------------------------------------------------------------
    # @param:
    #   - :idscpi* [Integer] ID le la SCPI
    # @return: [Valeurs]
    #   - :date      [String] Date
    #   - :souscript [String] Valeur de souscription
    #   - :rachat    [String] Valeur de rachat
    define_request(:scpi_valuation, 1002, %i[idscpi]) { |response| response.dig(:api, :valeur) }

    define_request(:scpi_bare_ownerships, 1003, %i[idscpi]) { |response| response.dig(:api, :valeur) }

    define_request(:document_categories, 1004) { |response| response.dig(:api, :catdoc) }

    define_request(:document_types, 1005, %i[idcat]) { |response| response.dig(:api, :typedoc) }

    # ========================================================================
    # > Requetes type 2000 environnement
    # ========================================================================

    define_request(
      :udpate_partner,
      2001,
      %i[idcli refext],
      %i[idapporteur nom prenom add1 add2 cp ville tel mobile mail bic iban reinvest]
    ) { |response| response.dig(:api, :res) }
  end
end
