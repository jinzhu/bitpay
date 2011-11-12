$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bitpay"
  s.version     = "0.0.1"
  s.authors     = ["Jinzhu"]
  s.email       = ["wosmvp@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Bitpay"
  s.description = "Bitpay"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
