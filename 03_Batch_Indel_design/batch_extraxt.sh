# 为适配python输出的WGA indel位点，稍作编辑
# 注意alignment block是比对后的fasta，存在gap！

INTERVAL_FILE="../Vada2H_interval.fa"

lineflag=0

cat report.txt | while read line
do
	echo ${line}
	if [ ${lineflag} -eq 0 ]
	then
		lineflag=1
		continue
	fi

	echo ${lineflag}

	# 染色体名（区块名）、序号、相对ref序列的坐标
	CHROM=$(echo ${line} | awk '{print $1}')
	NUM=$(echo ${line} | awk '{print $2}')
	POS=$(echo ${line} | awk '{print $6}')

	echo "${CHROM}_${NUM}"

	# 计算上下游坐标
	START=$((${POS} - 300))
	END=$((${POS} + 300))

	echo ${START} ${END}

	# 使用seqkit提取序列，并保存到以染色体名和坐标命名的文件中
	seqkit subseq -Rr "${START}:${END}" ${INTERVAL_FILE} > seqextr/${CHROM}_${NUM}_${POS}.fa
	
	lineflag=$((${lineflag} + 1))
done
