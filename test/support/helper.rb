require "dotenv/load"

require_relative "../../lib/souscript_sdk"

def init_souscript_sdk
  SouscriptSDK.new(
    base_url: ENV["SOUSCRIPT_BASE_URL"],
    user_name: ENV["SOUSCRIPT_USER_NAME"],
    password: ENV["SOUSCRIPT_PASSWORD"]
  )
end
