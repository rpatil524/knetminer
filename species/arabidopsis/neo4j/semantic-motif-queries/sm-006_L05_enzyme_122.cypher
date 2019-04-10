MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [rel_10_10:h_s_s|ortho|xref*0..1] -> (protein_10:Protein)
  - [is_a_10_122:is_a] -> (enzyme_122:Enzyme)
RETURN path