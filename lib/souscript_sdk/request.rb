class SouscriptSDK
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

    # Valorisations SCPI : liste des valeurs historiques de souscription
    # ------------------------------------------------------------------------
    # @param:
    #   - :idscpi* [Integer] ID de la SCPI
    # @return: [Valeurs]
    #   - :date      [String] Date
    #   - :souscript [String] Valeur de souscription
    #   - :rachat    [String] Valeur de rachat
    define_request(:scpi_valuations, 1002, %i[idscpi]) { |response| response.dig(:api, :valeur) }

    # Table de demembrement : liste des valeurs des pourcentages de démembrement
    # ------------------------------------------------------------------------
    # @param:
    #   - :idscpi* [Integer] ID de la SCPI
    # @return: [Valeurs]
    #   - :duree       [String] Durée en année
    #   - :nuepro      [String] Valeur nue propriété en %
    #   - :usufr       [String] Valeur usufruit en %
    define_request(:scpi_bare_ownerships, 1003, %i[idscpi]) { |response| response.dig(:api, :valeur) }

    # catégorie document : liste des catégories de documents
    # ------------------------------------------------------------------------
    # @return: [catdoc]
    #   - :nom    [String] Nom du document
    #   - :id     [String] ID du document
    define_request(:document_categories, 1004) { |response| response.dig(:api, :catdoc) }

    # type document : liste des types de documents
    # ------------------------------------------------------------------------
    # @param:
    #   - :idcat*  [integer] Identifiant de la catégorie
    # @return: [typedoc]
    #   - :nom [String] Nom du document
    #   - :id  [String] ID du document
    define_request(:document_types, 1005, %i[idcat]) { |response| response.dig(:api, :typedoc) }

    # ========================================================================
    # > Requetes type 2000 synchronisation
    # ========================================================================

    # modification d’un associe : résultat de la modification
    # ------------------------------------------------------------------------
    # @param:
    #   - :idcli*       [integer] Identifiant de base de l'associé
    #   - :refext*      [integer] Référence externe de l’associé
    #   - :idapporteur  [integer] ID interne souscript du tiers apporteur (cgp)
    #                             si la valeur passé est nulle, l’associé n’est rattaché à aucun apporteur
    #                             si la valeur est non nulle, l’id doit correspondre à un tiers existant, sinon la requête n’aura aucun effet et reçoit un message d’erreur.
    #   - :nom          [string] Nom de famille du souscripteur
    #   - :prenom       [string] Prénom du souscripteur
    #   - :add1         [string] Adresse 1
    #   - :add2         [string] Adresse 2
    #   - :cp           [string] Code postal
    #   - :ville        [string] Ville de l’adresse
    #   - :tel          [string] Téléphone fixe
    #   - :mobile       [string] Mobile
    #   - :mail         [string] Adresse email
    #   - :bic          [string] BIC du compte bancaire
    #   - :iban         [string] IBAN du compte bancaire
    #   - :reinvest     [integer] 1 : réinvestissement des dividendes demandé
    #                             0 : pas de réinvestissement des dividendes
    # @return:
    #   - :res    [String] Résultat de la modification
    define_request(
      :udpate_partner,
      2001,
      %i[idcli refext],
      %i[idapporteur nom prenom add1 add2 cp ville tel mobile mail bic iban reinvest reinvseuil reinvpc]
    ) { |response| response.dig(:api, :res) }

    # création/modification d’une société : résultat de la modification
    # ------------------------------------------------------------------------
    # @param:
    #   - :idsoc*       [integer] Identifiant de base de la société
    #   - :refext*      [integer] Référence externe de la société
    #   - :creamod*     [integer] Mode de la requête (1 pour création, 2 pour modification)
    #   - :raison       [string] Raison sociale
    #   - :rcs          [integer] Numéro rcs
    #   - :add1         [string] Adresse 1
    #   - :cp           [string] Code postal
    #   - :ville        [string] Ville de l’adresse
    #   - :tel          [string] Téléphone fixe
    #   - :mobile       [string] Mobile
    #   - :mail         [string] Adresse email
    #   - :bic          [string] BIC du compte bancaire
    #   - :iban         [string] IBAN du compte bancaire
    #   - :tableretro   [string] Table texte des tarifs de rétrocession selon la scpi
    #                            (séparateur de colonne « ;», séparateur de ligne «*»)
    #                            col 1 : id base interne souscript de la scpi (connu via requête 1001)
    #                            col 2 : nom de la scpi (connu via requête 1001)
    #                            col 3 : commission % (. décimal)
    #                            col 4 : commission sur encours (0 ou 1)
    #                            col 5 : commission sur encours % (. décimal)
    #                            exemple : "1;vendôme région;7.5;0*4;fair invest;6;1;3.5"
    #   - :rc_contact   [string] Nom du destinataire des relevés de collecte
    #   - :rc_tel       [String] Téléphone du destinataire des relevés de collecte
    #   - :rc_mobile    [String] Mobile du destinataire des relevés de collecte
    #   - :rc_mail      [String] Adresse mail du destinataire des relevés de collecte
    # @return:
    #   - :idint  [String] ID interne Sourcript de la société créée
    #   - :refext [String] Paramètre refext passé en paramètre
    #   - :res    [String] Résultat de la modification
    define_request(
      :creation_udpate_company,
      2002,
      %i[idsoc idgr refext creamod],
      %i[raison rcs add1 cp ville tel mobile mail bic iban tableretro rc_contact rc_tel rc_mobile rc_mail]
    ) { |response| response.dig(:api) }

    # création/modification d’un tiers : résultat de la modification
    # ------------------------------------------------------------------------
    # @param:
    #   - :idcgp*           [integer] Identifiant de base du tiers en cas de modification
    #   - :refext*          [integer] Référence externe du tiers
    #   - :creamod*         [integer] Mode de la requête (1 pour création, 2 pour modification)
    #   - :idsoc*           [integer] Identifiant de base de la société à laquelle appartient le tiers
    #   - :nom              [string] Nom de famille du souscripteur
    #   - :prenom           [string] Prénom du souscripteur
    #   - :add1             [string] Adresse 1
    #   - :datenaissance    [string] Date de naissance
    #   - :villenaissance   [string] Ville de naissance
    #   - :paysnaissance    [string] Pays de naissance
    #   - :cp               [string] Code postal
    #   - :ville            [string] Ville de l’adresse
    #   - :tel              [string] Téléphone fixe
    #   - :mobile           [string] Mobile
    #   - :mail             [string] Adresse email
    #   - :bic              [string] BIC du compte bancaire
    #   - :iban             [string] IBAN du compte bancaire
    # @return:
    #   - :res      [String] Résultat de la modification
    define_request(
      :creation_udpate_third_party,
      2003,
      %i[idcgp refext creamod idsoc],
      %i[nom prenom add1 datenaissance villenaissance paysnaissance cp ville tel mobile mail bic iban]
    ) { |response| response.dig(:api, :res) }

    # création/modification d’un tiers : résultat de la modification
    # ------------------------------------------------------------------------
    # @param:
    #   - :idverprog*   [Integer] Identifiant base du versement programmé (en cas de modification)
    #   - :refext*      [String] Référence externe du versement programmé
    #   - :periodicite  [Integer] 1 : mensuel
    #                             2 : trimestriel
    #                             3 : semestriel
    #                             4 : annuel
    #   - :mois1        [String] (AAAAMM) premier mois d’application (une modification pour une date postérieure si la date actuelle est passée sera rejetée en erreur)
    #   - :typevp       [Integer] 1 : Montant en euros
    #                              2 : Montant en parts
    #   - :montantvp    [Float] Type 1, montant en euros à prélever
    #                           Type 2, nombre de parts (achat à cours inconnu, le montant équivalent sera calculé au moment de l’application en fonction de la valeur de souscription du moment)
    #   - :arevocation  [Integer] 1 : le programme courra sans date limite
    #                              0 : le programme courra jusqu’à la date limite, qui doit alors impérativement être fixée
    #   - :datelimvp    [String] (AAAAMMJJ) Si « à révocation » vaut 0, alors définit la date limite d’application
    #   - :actifvp      [Integer] 0 : pour désactiver temporairement les applications
    #                             1 : pour (ré)activer les applications
    # @return:
    #   - :res      [String] Résultat de la modification
    define_request(
      :udpate_programmed_payment,
      2004,
      %i[idverprog refext],
      %i[periodicite mois1 typevp montantvp arevocation datelimvp actifvp]
    ) { |response| response.dig(:api, :res) }

    # ========================================================================
    # > Requetes type 3000 associe
    # ========================================================================

    # liste des associes : liste des associe
    # ------------------------------------------------------------------------
    # @return: [Associe]
    #   - :type    [String] Type de client
    #   - :rsoc    [String] Raison sociale des personnes morales
    #   - :civ     [String] Civilité
    #   - :prenom  [String] Prénom pour une personne physique
    #   - :nom     [String] Nom pour une personne physique
    #   - :id      [String] ID
    #   - :codeid  [String] ID SGP du client
    #   - :refext  [String] Référence externe du client
    #   - :datemaj [String] Dernière date de mise à jour manuelle
    define_request(:get_partners_list, 3001) { |response| response.dig(:api, :associe) }

    # liste des associes : liste des associe
    # ------------------------------------------------------------------------
    # @param:
    #   - idcli* [Integer] Identifiant du client
    # @return: [Associe]
    #   - :idapp  [String] ID  de l’apporteur (Tiers CGP) auquel l’associé est rattaché
    #   - :raisoc [String] Raison sociale de l’associé personne morale, sinon vide
    #   - :typeas [String] Type de personne juridique (1 Personne physique, 2 personne morale)
    #   - :civili [String] Civilité (1 Monsieur, 2 Madame, 3 M M)
    #   - :prenom [String] Prénom de l’associé personne physique ou du contact personne morale
    #   - :nomass [String] Nom de l’associé personne physique ou du contact personne morale
    #   - :rcsoci [String] Numéro de RCS ou SIREN, SIRET de l’associé personne morale
    #   - :datena [String] Date de naissance de l’associé personne physique
    #   - :adres1 [String] Première ligne d’adresse postale
    #   - :adres2 [String] Seconde ligne d’adresse postale
    #   - :codpos [String] Code postal
    #   - :villea [String] Ville de l’adresse postale
    #   - :paysad [String] Pays de l’adresse postale
    #   - :teleph [String] Téléphone fixe
    #   - :mobile [String] Téléphone mobile
    #   - :admail [String] Adresse email
    #   - :cptiba [String] IBAN du compte bancaire
    #   - :cptbic [String] BIC du compte bancaire
    #   - :catpro [String] Catégorisation investisseur professionnel (0 Non, 1 Oui)
    #   - :cofisc [String] Code fiscal (1 imposition à l’IR, 2 Imposition à l’IS)
    #   - :paysna [String] Pays de naissance
    #   - :villen [String] Ville de naissance
    #   - :sitmat [String] Situation matrimoniale
    #   - :regmat [String] Régime matrimonial
    #   - :capjur [String] Incapacité juridique (0 Non, 1 Oui)
    #   - :profes [String] Profession
    #   - :resfis [String] Pays de résidence fiscale
    #   - :exppol [String] Personne exposée politiquement (0 non, 1 oui)
    #   - :nirisk [String] Niveau de risque (1 faible, 2 modéré, 3 élevé)
    #   - :avalid [String] Statut du client à valider (cas API CGP) (1 Validé  2 refusé  3 à Valider)
    #   - :rinvok [String] Réinvestissement des dividendes (0 non  1 oui)
    #   - :rinvse [String] Seuil en euro des dividendes à réinvestir
    #   - :prbspp [String] Préférence communication par mail du bulletin de souscription ppro ou nuepro (0 non  1 oui)
    #   - :prbsus [String] Préférence communication par mail du bulletin de souscription usufruit (0 non  1 oui)
    #   - :prifup [String] Préférence communication par mail des IFU ppro ou nuepro (0 non  1 oui)
    #   - :prifuu [String] Préférence communication par mail des IFU usufruit (0 non  1 oui)
    #   - :pragpp [String] Préférence communication par mail des assemblées générales ppro ou nuepro (0 non  1 oui)
    #   - :pragus [String] Préférence communication par mail des assemblées générales usufr (0 non  1 oui)
    #   - :prinfp [String] Préférence communication par mail des autres informations ppro ou nuepro (0 non  1 oui)
    #   - :prinfu [String] Préférence communication par mail des autres informations usufr (0 non  1 oui)
    #   - :dispob [String] Dispense de prélèvement obligatoire (0 non  1 oui)
    define_request(:get_partner_details, 3002, %i[idcli]) { |response| response.dig(:api, :associe) }

    # liste des parts : liste des parts
    # ------------------------------------------------------------------------
    # @param:
    #   - idcli* [Integer] Identifiant du client
    # @return: [Souscript]
    #   - :idsouscript  [String] Identifiant de la souscription (pour lien avec doc 3005)
    #   - :idscpi       [String] Identifiant de la SCPI (connu par requête 1001)
    #   - :nomscpi      [String] Nom de la SCPI
    #   - :nbparts      [String] Nombre de parts souscrites
    #   - :typepart     [String] Type des parts souscrites
    #                            1 Pleine propriété
    #                            2 Nue propriété
    #                            3 Usufruit
    #   - :numparts     [String] chaine numéros des parts (format « Microsoft »)
    #   - :valo         [String] réel Valeur de souscription
    #   - :montant      [String] Montant souscrit
    #   - :date         [String] Date de la souscription
    #   - :datej        [String] Date de jouissance
    #   - :datef        [String] Date de fin de jouissance
    #   - :statut       [String] 1 ACTIVE  2 MUTEE 3 ETEINTE
    define_request(:get_share_list, 3003, %i[idcli]) do |response|
      res = response.dig(:api, :souscript)
      res.is_a?(Hash) ? [res] : res
    end

    # liste des mouvements financiers : liste des mouvements financiers
    # ------------------------------------------------------------------------
    # @param:
    #   - idcli* [Integer] Identifiant du client
    # @return: [Mvt]
    #   - :date     [String] Date du paiement
    #   - :lib      [String] Libellé explicatif du mouvement
    #   - :sens     [String] 1 Payé par le client  2 Reçu par le client
    #   - :montant  [String] Montant en euros
    define_request(:get_financial_flows_list, 3004, %i[idcli]) do |response|
      res = response.dig(:api, :mvt)
      res.is_a?(Hash) ? [res] : res
    end

    # liste des documents d'un client : liste des documents d'un client
    # ------------------------------------------------------------------------
    # @param:
    #   - idcli* [Integer] Identifiant du client
    # @return: [Doc]
    #   - :date         [String] Date De téléchargement ou d’envoi
    #   - :lib          [String] Libellé descriptif du document
    #   - :ok           [String] Document validé par le back office (0 non 1 Payé par le client  2 Reçu par le client)
    #   - :ko           [String] Document invalidé par le back office (0 non  1 oui)
    #   - :catdoc       [String] Catégorie ou famille de document (requêtes 1004)
    #   - :typedoc      [String] Type de document (requêtes 1005)
    #   - :iddoc        [String] Identifiant du document
    #   - :idsouscript  [String] Identifiant de la souscription (Si 0, il s’agit d’un document personnel)
    #   - :datemaj      [String] Dernière date de téléchargement du document
    define_request(:get_customer_documents_list, 3005, %i[idcli]) { |response| response.dig(:api, :doc) }

    # telecharger un document : document
    # ------------------------------------------------------------------------
    # @param:
    #   - iddoc* [Integer] Identifiant du document
    # @return:
    #   - :err         [String] Message d’erreur ou de confirmation
    #                           0: l’IDDOC est fausse (ne pointe pas sur un document existant)
    #                           1: l’IDDOC est bonne mais pointe sur un document dont la pièce n’a pas été téléchargée dans la GED.
    #                           2: OK, on renvoie un document contenu dan la GED, codé en base 64, dans le champ <B64>
    #   - :doc
    #       - :b64     [String] Buffer du document codé en base 64
    define_request(:download_document, 3006, %i[iddoc]) { |response| response.dig(:api, :doc) }

    # liste des versements programmes d’un associe : liste des versements programmes d’un associe
    # ------------------------------------------------------------------------
    # @param:
    #   - idcli* [Integer] Identifiant du client
    # @return: [verprog]
    #   - :idint    [String] Identifiant base du dossier de versement programmé
    #   - :refext   [String] Référence externe du versement programmé
    #   - :date     [String] Date de création du dossier de versement programmé
    #   - :idscpi   [String] Identifiant de la SCPI (connu par requête 1001)
    #   - :nomscpi  [String] Nom de la SCPI
    #   - :mois1    [String] Premier mois d’application
    #   - :arevoc   [String] 1 programme sans date limite prévue, 0 programme avec date limite prévue
    #   - :datelim  [String] Date limite d’application
    #   - :actif    [String] 1 programme activé, 0 programme désactivé
    #   - :type     [String] 1 montant en euros, 2 montant en nombre de parts
    #   - :montant  [String] Montant souscrit en euros ou en nombre de parts delon type
    define_request(:get_partner_programmed_payement_list, 3007, %i[idcli]) { |response| response.dig(:api, :verprog) }

    # ========================================================================
    # > Requetes type 4000 cgp
    # ========================================================================

    # liste de tous les cgp : liste de tous les cgp
    # ------------------------------------------------------------------------
    # @return: [cgp]
    #   - :civ      [String] Civilité
    #   - :prenom   [String] Prénom
    #   - :nom      [String] Nom
    #   - :mail     [String] adresse email
    #   - :id       [String] Identifiant du CGP
    #   - :refext   [String] Référence externe du cgp
    #   - :ids      [String] Identifiant de la société de rattachement
    #   - :dgs      [String] Droits global de vue sur la société
    #                        si oui, cette personne est habilitée à accéder à tous les clients de la société
    #                        0 non  1 oui
    #   - :idg      [String] Identifiant du groupement de rattachement
    #   - :dgg      [String] Droits global de vue sur le groupement
    #   - :datemaj  [String] Dernière date de mise à jour manuelle de la fiche
    define_request(:get_cgp_list, 4001) { |response| response.dig(:api, :cgp) }

    # clients cgp : liste de tous les clients du cgp
    # ------------------------------------------------------------------------
    # @param:
    #   - :idcgp* [Integer] Identifiant du CGP
    # @return: [client]
    #   - :type     [String] 1 personne physique, 2 personne morale
    #   - :rsoc     [String] Raison sociale de personnes morale
    #   - :civ      [String] Civilité (1 Monsieur    2 Madame   3 M M)
    #   - :prenom   [String] Prenom
    #   - :nom      [String] Nom
    #   - :mail     [String] Adresse email duc lient
    #   - :id       [String] Identifiant du client
    #   - :codeid   [String] Identifiant à usage interne SGP
    define_request(:get_cgp_customers_list, 4002, %i[idcgp]) { |response| response.dig(:api, :client) }

    # ========================================================================
    # > Requetes type 5000 sociétés
    # ========================================================================

    # groupements : liste des groupements
    # ------------------------------------------------------------------------
    # @return: [groupe]
    #   - :nom   [String] Nom du groupement
    #   - :id    [String] ID du groupement
    define_request(:get_group_list, 5001) { |response| response.dig(:api, :groupe) }

    # CGP de groupement : liste des cgp du groupement
    # ------------------------------------------------------------------------
    # @param:
    #   - :idgroupe* [Integer] Identifiant du groupement
    # @return: [cgp]
    #   - :civ       [String] Civilité (1 Monsieur    2 Madame)
    #   - :prenom    [String] Prenom
    #   - :nom       [String] Nom
    #   - :id        [String] Identifiant du CGP
    #   - :ids       [String] Identifiant de la société de rattachement
    #   - :dgs       [String] Droits global de vue sur la société
    #                         si oui, cette personne est habilitée à accéder à tous les clients de la société
    #                         0 non  1 oui
    #   - :idg       [String] Identifiant du groupement de rattachement (0 si non rattaché à un groupement)
    #   - :dgg       [String] Droits global de vue sur le groupement
    define_request(:get_group_cgp_list, 5002, %i[idgroupe]) { |response| response.dig(:api, :societe) }

    # sociétés : liste des sociétés (ou cabinets)
    # ------------------------------------------------------------------------
    # @return: [societe]
    #   - :nom       [String] Raison sociale de la société
    #   - :id        [String] Identifiant base de la société
    #   - :refext    [String] Référence externe de la société
    #   - :datemaj   [String] Dernière date de mise à jour manuelle de la fiche
    define_request(:get_companies_list, 5003) { |response| response.dig(:api, :societe) }

    # CGP de société : liste des cgp de la societe (du cabinet
    # ------------------------------------------------------------------------
    # @param:
    #   - :idsoc* [Integer] Identifiant de la société
    # @return: [cgp]
    #   - :civ       [String] Civilité (1 Monsieur    2 Madame)
    #   - :prenom    [String] Prenom
    #   - :nom       [String] Nom
    #   - :id        [String] Identifiant du CGP
    #   - :refext    [String] Référence externe du cgp
    #   - :ids       [String] Identifiant de la société de rattachement
    #   - :dgs       [String] Droits global de vue sur la société
    #                         si oui, cette personne est habilitée à accéder à tous les clients de la société
    #                         0 non  1 oui
    #   - :idg       [String] Identifiant du groupement de rattachement (0 si non rattaché à un groupement)
    #   - :dgg       [String] Droits global de vue sur le groupement
    define_request(:get_companies_cgp_list, 5004, %i[idsoc]) { |response| response.dig(:api, :cgp) }
  end
end
