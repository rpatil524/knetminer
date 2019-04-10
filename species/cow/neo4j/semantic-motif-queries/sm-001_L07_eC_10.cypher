MATCH path = (gene_1:Gene{ iri: $startIri })
  - [ortho_1_2:ortho] -> (gene_2:Gene)
  - [enc_2_3:enc] -> (protein_3:Protein)
  - [it_wi_3_3:it_wi*0..1] -> (protein_3:Protein)
  - [cat_c_3_10:cat_c] -> (eC_10:EC)
RETURN path