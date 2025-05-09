# 统计blast结果
echo -e "id\thits_number" > blast.report.txt
for i in $(ls blastout/)
do
	seqname=$(echo ${i} | sed 's/\.fa\.blast\.txt//')
	hits=$(grep -vc '^#' blastout/${i})
	echo -e "${seqname}\t${hits}" >> blast.report.txt
done
