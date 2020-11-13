prepare do
  init_souscript_sdk
end

test "Type 1000" do
  scpis = SouscriptSDK.scpis
  assert scpis.is_a?(Array)
  assert scpis.first[:nom].present?
  scpi_id = scpis.first[:id]

  scpi_valuations = SouscriptSDK.scpi_valuations(idscpi: scpi_id)
  assert scpi_valuations.is_a?(Array)
  assert scpi_valuations.first[:rachat].present?
end
