input_report="../select_Indel/selected_Indel.txt"
flank_len=300
ref="L94.fasta"

cat ${input_report} | while read line
do
  chr=$(echo "${line}" | cut -f 1)
  pos=$(echo "${line}" | cut -f 2)

  start=$((pos - flank_len))
  end=$((pos + flank_len))

  seqkit grep -p ${chr} ${ref} | seqkit subseq -Rr "${start}:${end}" > seqextr/${chr}_${pos}.fa
done
