
Gem::Specification.new do |s|
	s.name = 'rdf_inference'
	s.version = '0.0.6'
	s.date = '2019-01-02'
	s.summary = "Inference engine"
	s.description = "Inference engine v0.0.6 - performance update"
	s.authors = ["WiDu"]
	s.email = 'wdulek@gmail.com'
	s.files = ["lib/rdf_inference.rb"]
	s.homepage = 'https://github.com/widu/rdf_inference'
	s.license = 'MIT'
	s.add_runtime_dependency "linkeddata"
	s.add_runtime_dependency "sparql"
end

