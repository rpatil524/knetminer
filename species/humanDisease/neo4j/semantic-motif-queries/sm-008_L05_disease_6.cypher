MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [rel_10_10:it_wi|ortho*0..1] -> (protein_10:Protein)
  - [inv_in_10_6:inv_in] -> (disease_6:Disease)
RETURN path