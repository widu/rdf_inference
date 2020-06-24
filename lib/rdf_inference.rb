require 'linkeddata'
require 'sparql'

include RDF

class RdfInference

	def initialize
		prefix = "PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
		PREFIX rdfs: 	<http://www.w3.org/2000/01/rdf-schema#>
		PREFIX wdc:    <http://vieslav.pl/csv/0.1/>
		PREFIX owl:  <http://www.w3.org/2002/07/owl#> \n"
		@query_list = {}

		@query_list[:subClassOf] = prefix + "CONSTRUCT {?r rdf:type ?B .}  
		WHERE { ?A rdfs:subClassOf ?B .
		?r rdf:type ?A .
		FILTER NOT EXISTS {?r rdf:type ?B}
		}" 
		@query_list[:subPropertyOf] = prefix + "CONSTRUCT {?x ?r ?y .
		[ rdf:subject ?x;
		rdf:predicate ?r;
		rdf:object ?y ] a wdc:DerivationRelationship .}  
		WHERE { 
		?q rdfs:subPropertyOf ?r .
		?x ?q ?y .
		
		FILTER NOT EXISTS {?x ?r ?y }
		}"
		@query_list[:RDFS_Plus_TransitiveProperty] = prefix + "CONSTRUCT {?x ?p ?z .
		[ rdf:subject ?x;
		rdf:predicate ?p;
		rdf:object ?z ] a wdc:DerivationRelationship .}  
		WHERE { 
		?p rdf:type owl:TransitiveProperty .
		?x ?p ?y .
		?y ?p ?z .
		
		FILTER NOT EXISTS {?x ?p ?z }
		}"

		@query_list[:WIDU_shortCut] = prefix + "CONSTRUCT {?x ?p ?z .
		[ rdf:subject ?x;
		rdf:predicate ?r;
		rdf:object ?y ] a wdc:DerivationRelationship .}  
		WHERE { 
		?class1 wdc:shortCut ?class3.
		?x a ?class1 .
		?y a ?class2 .
		?z a ?class3 .
		?x ?p ?y .
		?y ?p ?z .
		
		FILTER NOT EXISTS { ?x ?p ?z }
		FILTER NOT EXISTS { ?y a ?class1 }
		FILTER NOT EXISTS { ?y a ?class3 }
		}"

		@query_list[:WIDU_isWeakerThan1] = prefix + "CONSTRUCT {?x ?p ?z .
		[ rdf:subject ?x;
		rdf:predicate ?p;
		rdf:object ?z ] a wdc:DerivationRelationship .}  
		WHERE { 
		?p wdc:isWeakerThan ?p2 .
		?x ?p ?y .
		?y ?p2 ?z .
		
		FILTER NOT EXISTS { ?x ?p ?z }
		
		}"


		@query_list[:WIDU_isWeakerThan2] = prefix + "CONSTRUCT {?x ?p2 ?z .
		[ rdf:subject ?x;
		rdf:predicate ?p2;
		rdf:object ?z ] a wdc:DerivationRelationship .}  
		WHERE { 
		?p2 wdc:isWeakerThan ?p .	
		?x ?p ?y .
		?y ?p2 ?z .
		
		FILTER NOT EXISTS { ?x ?p2 ?z }
		
		}"



		@query_list[:RDFS_Plus_inverseOf9] = prefix + "CONSTRUCT {?y ?q ?x .
		[ rdf:subject ?x;
		rdf:predicate ?r;
		rdf:object ?y ] a wdc:DerivationRelationship .}  
		WHERE { 
		?p owl:inverseOf ?q .
		?x ?p ?y .
		FILTER (?p != owl:inverseOf)
		FILTER NOT EXISTS { ?y ?q ?x }
		}"

		@query_list[:RDFS_domain] = prefix + "CONSTRUCT {?x rdf:type ?D .}  
		WHERE { ?P rdfs:domain ?D .
		?x ?P ?y .
		FILTER NOT EXISTS { ?x rdf:type ?D }
		}"

		@query_list[:RDFS_range] = prefix + "CONSTRUCT {?y rdf:type ?D .}  
		WHERE { ?P rdfs:range ?D .
		?x ?P ?y .
		FILTER NOT EXISTS { ?y rdf:type ?D }
		}"

	end

	def inference(graph)
		@rdfs_inferred = RDF::Repository.new
		@rdfs_inferred_all = RDF::Repository.new
		begin
			@rdfs_inferred = RDF::Repository.new
			@query_list.each do |klucz, query|
				puts klucz
				@rdfs_inferred << SPARQL.execute(query, graph)
			end
			graph << @rdfs_inferred
			@rdfs_inferred_all << @rdfs_inferred
			puts "Inference count:"
			puts @rdfs_inferred.count
		end	 until @rdfs_inferred.count == 0
		puts "Inference count all:"
		puts @rdfs_inferred_all.count
		@rdfs_inferred_all
	end


end
