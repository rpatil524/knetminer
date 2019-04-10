MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [rel_10_10:it_wi|ortho*0..1] -> (protein_10:Protein)
  - [enc_10_17:enc] -> (gene_17:Gene)
  - [has_variation_17_13:has_variation] -> (sNP_13:SNP)
  - [associated_with_13_14:associated_with] -> (trait_14:Trait)
RETURN path