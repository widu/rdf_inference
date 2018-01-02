
Gem::Specification.new do |s|
	s.name = 'rdf_inference'
	s.version = '0.0.0'
	s.date = '2018-01-02'
	s.summary = "Inference engine"
	s.description = "Inference engine"
	s.authors = ["WiDu"]
	s.email = 'wdulek@gmail.com'
	s.files = ["lib/rdf_inference.rb"]
	s.homepage = 'https://github.com/widu/rdf_inference'
	s.license = 'MIT'
	s.add_runtime_dependency "linkeddata"
	s.add_runtime_dependency "sparql"
end

