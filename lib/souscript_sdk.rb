require_relative "souscript_sdk/init"
require_relative "souscript_sdk/http_call"
require_relative "souscript_sdk/request"

module SouscriptSDK
  extend Init
  extend HTTPCall
  extend Request
end
