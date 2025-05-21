mkdir -p primers/

cat blast.report.txt | while read i
do
	if [ $(echo "${i}" | cut -f 2) -eq 1 ]
	then
		id=$(echo "${i}" | cut -f 1)

		echo ${id}

		python primer3_batchdesign.py -i seqextr/${id}.fa -o primers/${id}.primers.txt
	fi
done
