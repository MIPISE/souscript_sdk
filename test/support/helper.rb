require_relative "../../lib/souscript_sdk"

def init_souscript_sdk
  SouscriptSDK.init(
    base_url: "https://www.souscript.com/SOUSCRIPT/SOUSCRIPT_WEB/FR/APIINT.AWP",
    user_name: "SAGATO",
    password: "PURITA"
  )
end
