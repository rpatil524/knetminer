MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [xref_10_10:xref*0..3] -> (protein_10:Protein)
  - [pub_in_10_2:pub_in] -> (publication_2:Publication)
RETURN path