Gem::Specification.new do |s|
  s.name = "souscript_sdk"
  s.version = "0.0.1"
  s.summary = "Gem for Souscript API"
  s.description = "Gem for Souscript API"
  s.authors = ["Guillaume BOUDON", "Nathan LEBAS"]
  s.homepage = "https://github.com/mipise/souscript_sdk"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "activesupport", ">= 5.1.0"
end
