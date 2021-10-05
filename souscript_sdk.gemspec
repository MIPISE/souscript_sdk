Gem::Specification.new do |s|
  s.name = "souscript_sdk"
  s.version = "2.0.0"
  s.summary = "Gem for Souscript API"
  s.description = "Gem for Souscript API"
  s.authors = ["Guillaume BOUDON", "Nathan LEBAS"]
  s.homepage = "https://github.com/mipise/souscript_sdk"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_dependency "activesupport", ">= 5.1.0"

  s.add_development_dependency "cutest", "~> 1.2"
  s.add_development_dependency "dotenv", "~> 2.7"
end
