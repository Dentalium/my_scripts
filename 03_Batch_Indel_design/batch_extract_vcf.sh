input_vcf="../05_bcf_bcftools/merged_Indel_001274l.norm.filter.vcf"
flank_len=300
ref="../../rawdata/ref/pm37.fa"

mkdir -p seqextr/

bcftools view -H ${input_vcf} | while read line
do
	#echo ${line}
  chr=$(echo "${line}" | cut -f 1)	#;echo ${chr}
  pos=$(echo "${line}" | cut -f 2)	#;echo ${pos}

  start=$((pos - flank_len))
  end=$((pos + flank_len))

  seqkit grep -p ${chr} ${ref} | seqkit subseq -Rr "${start}:${end}" > seqextr/${chr}_${pos}.fa
done
