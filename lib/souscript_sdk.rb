require_relative "souscript_sdk/init"
require_relative "souscript_sdk/http_call"
require_relative "souscript_sdk/request"
require_relative "souscript_sdk/helper"

class SouscriptSDK
  include Init
  include HTTPCall
  include Request
  include Helper
end
