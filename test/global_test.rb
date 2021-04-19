prepare do
  init_souscript_sdk
end

test "Type 1000" do

  #1001
  scpis = SouscriptSDK.scpis
  assert scpis.is_a?(Array)
  assert scpis.first[:nom].present?
  scpi_id = scpis.first[:id]

  #1002
  scpi_valuations = SouscriptSDK.scpi_valuations(idscpi: scpi_id)
  assert scpi_valuations.is_a?(Array)
  assert scpi_valuations.first[:rachat].present?

  #1003
  scpi_bare_ownerships = SouscriptSDK.scpi_bare_ownerships(idscpi: scpi_id)
  assert scpi_bare_ownerships.is_a?(Array)
  assert scpi_bare_ownerships.first[:nuepro].present?

  #1004
  document_categories = SouscriptSDK.document_categories()
  assert document_categories.is_a?(Array)
  assert document_categories.first[:id].present?
  document_categories_id = document_categories.first[:id]

  #1005
  document_types = SouscriptSDK.document_types(idcat: document_categories_id)
  assert document_types.is_a?(Array)
  assert document_types.first[:nom].present?
end

test "Type 3000 and 2000" do

  #3001
  #problème d'acquisition de refext dans cette requête
  partners_list = SouscriptSDK.get_partners_list()
  assert partners_list.is_a?(Array)
  assert partners_list.first[:id].present?
  partner_id = partners_list.first[:id]
  partners_refext = nil

  #2001
  udpate_partner = SouscriptSDK.udpate_partner(idcli: partner_id, refext: partners_refext)
  assert udpate_partner.is_a?(String)

  #3002
  partner_details = SouscriptSDK.get_partner_details(idcli: partner_id)
  assert partner_details.is_a?(Hash)
  assert partner_details[:idapp].present?

  #3003
  share_list = SouscriptSDK.get_share_list(idcli: partner_id)
  assert share_list.is_a?(Hash)
  assert share_list[:idscpi].present?

  #3004
  #Ne renvoie qu'un hash et pas une liste ce qui est contre intuitif'
  financial_flows_list = SouscriptSDK.get_financial_flows_list(idcli: partner_id)
  assert financial_flows_list.is_a?(Hash)
  assert financial_flows_list[:lib].present?

  #3005
  customer_documents_list = SouscriptSDK.get_customer_documents_list(idcli: partner_id)
  assert customer_documents_list.is_a?(Array)
  assert customer_documents_list.first[:iddoc].present?
  customer_document_id = customer_documents_list.first[:iddoc]

  #3006
  download_document = SouscriptSDK.download_document(iddoc: customer_document_id)
  assert download_document.is_a?(Hash)
  assert (download_document[:b64].present? or (download_document[:err].present? and (download_document[:err] == '0' or download_document[:err] == '1')))

  #3007
  partner_programmed_payement_list = SouscriptSDK.get_partner_programmed_payement_list(idcli: partner_id)
  assert partner_programmed_payement_list.is_a?(Hash)
  assert partner_programmed_payement_list[:idint].present?
  partner_programmed_payement_id = partner_programmed_payement_list[:idint]
  partner_programmed_payement_refext = nil

  #2004
  udpate_programmed_payement = SouscriptSDK.udpate_programmed_payement(idverprog: partner_programmed_payement_id, refext: partner_programmed_payement_refext)
  assert udpate_programmed_payement.is_a?(String)

end

test "Type 4000 and 2000" do

  #4001
  cgp_list = SouscriptSDK.get_cgp_list()
  assert cgp_list.is_a?(Array)
  assert cgp_list.first[:id].present?
  cgp_id = cgp_list.first[:id]
  cgp_refext = nil

  #2003
end

test "Type 5000 and 2000" do

  #5001
  group_list = SouscriptSDK.get_group_list()
  assert group_list.is_a?(Hash)
  assert group_list[:id].present?
  group_id = group_list[:id]

  #2002

  #5002
  group_cgp_list = SouscriptSDK.get_group_cgp_list(idgroupe: group_id)
  assert group_cgp_list.is_a?(Hash)
  assert group_cgp_list[:id].present?
  group_cgp_id = group_cgp_list[:id]

  #4002
  cgp_customers_list = SouscriptSDK.get_cgp_customers_list(idcgp: group_cgp_id)
  print(group_cgp_id)
  assert cgp_customers_list.is_a?(Hash)
  assert cgp_customers_list[:id].present?

  #5003
  companies_list = SouscriptSDK.get_companies_list()
  assert companies_list.is_a?(Array)
  assert companies_list.first[:id].present?
  companies_id = companies_list.first[:id]

  #5004
  companies_cgp_list = SouscriptSDK.get_companies_cgp_list(idsoc: companies_id)
  assert companies_cgp_list.is_a?(Array)
  assert companies_cgp_list.first[:id].present?

end