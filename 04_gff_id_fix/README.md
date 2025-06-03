用于修复基因组序列名称和注释文件中的染色体名称不一致的问题。

例如，这是`enembl plants`数据库收录的玉米参考基因组NAM5.0注释（[Zea_mays.Zm-B73-REFERENCE-NAM-5.0.60.chr.gff3](https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-61/gff3/zea_mays/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.61.chr.gff3.gz)）：

```
##gff-version 3
##sequence-region   1 1 308452471
#!genome-build nam-genomes Zm-B73-REFERENCE-NAM-5.0
#!genome-version Zm-B73-REFERENCE-NAM-5.0
#!genome-date 2019-12
#!genome-build-accession GCA_902167145.1
#!genebuild-last-updated 2019-12
1	Zm-B73-REFERENCE-NAM-5.0	chromosome	1	308452471	.	.	.	ID=chromosome:1
###
1	ensembl	gene	34617	40204	.	+	.	ID=gene:Zm00001eb000010;biotype=protein_coding;description=Zm00001e000001;gene_id=Zm00001eb000010;logic_name=cshl_gene
1	ensembl	mRNA	34617	40204	.	+	.	ID=transcript:Zm00001eb000010_T001;Parent=gene:Zm00001eb000010;biotype=protein_coding;tag=Ensembl_canonical;transcript_id=Zm00001eb000010_T001
```

这是`NCBI genome`收录的NAM5.0参考基因组序列（[GCF_902167145.1_Zm-B73-REFERENCE-NAM-5.0_genomic.fna.gz](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/902/167/145/GCF_902167145.1_Zm-B73-REFERENCE-NAM-5.0/GCF_902167145.1_Zm-B73-REFERENCE-NAM-5.0_genomic.fna.gz)）：

```
>ENA|LR618874|LR618874.1 Zea mays genome assembly, chromosome: 1
TCATGGCTATTTTCATAAAAAATGGGGGTTGTGTGGCCATTTATCATCGACTAGAGGCTC
ATAAACCTCACCCCACATATGTTTCCTTGCCATAGATTACATTCTTGGATTTCTGGTGGA
```

可见染色体名称并不一致，需要对注释文件进行修改
