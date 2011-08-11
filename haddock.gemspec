Gem::Specification.new do |s|
  s.date = "2011-08-11"

  s.name = "perch"
  s.version = "0.2.5"
  s.summary = %q{A more memorable password generator, based on haddock by Stephen Celis}
  s.description = %q{A more memorable password generator. Swordfish? No, I got tired of that. I changed it. Extends Haddock. Gives some fun.}

  s.files = [".autotest", "History.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "bin/ha-gen", "lib/haddock.rb", "test/names.txt", "test/test_haddock.rb"]
  s.executables = ["ha-gen"]
  s.default_executable = "ha-gen"
  s.require_paths = ["lib"]
  s.test_file = "test/test_haddock.rb"

  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis, Paul Brennan"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/yule/perch"
  s.rubyforge_project = "haddock"
end
