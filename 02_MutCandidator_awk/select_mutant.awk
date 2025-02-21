BEGIN{
#	paran=5
#	param=0    # 每个突变体每个contig携带的SNP最大数目，0表示不限制
	contig=""
	last_contig=""
}
/^#[^#]/{
	print
	# counter计数器初始化，每个元素代表一个突变体当前contig的SNP总数
	# SNPinfo记录了每一个突变体当前contig的各突变位点信息
	# samples记录各突变体名称
	for(i=10;i<=NF;i++){
		counter[i]=0
		SNPinfo[i]=""
		samples[i]=$i
	}
}
/^[^#]/{
	contig=$1
	# 若遇到新的contig，则输出上一个contig
	if(contig != last_contig){
		num_mutants=0
		for(i in counter){
			# 每个突变体每个contig携带的SNP数目不能超过param，否则不计
			if (param == 0 || counter[i] <= param) {
				# 当前突变体当前contig有SNP记为1，没有记为0
				num_mutants=num_mutants+(counter[i]>0)
			}
		}
		# 输出携带有效SNP突变体数量不小于paran的contig
		if(num_mutants >= paran){
			printf "candidate contig is %s, with %d mutants\n", last_contig, num_mutants
			# 输出各SNP
			for (i in counter) {
				# 每个突变体每个contig携带的SNP数目不能超过param，否则不输出
				if (param == 0 || counter[i] <= param) {
					printf "\t%s:\n", samples[i]
					# 提取当前contig当前突变体的各SNP
					split(SNPinfo[i],mutSNP,":")
					for (j in mutSNP) {
						# 分别输出当前contig当前突变体的各SNP
							printf "\t\t%s\n", mutSNP[j]
					}
				}
			}
		}
		# 重置计数器和SNPinfo
		for(i=10;i<=NF;i++){
                counter[i]=0
				SNPinfo[i]=""
        	}	
	}
	# 若没遇到新的SNP，则统计过滤后的SNP
	for(i in counter){
		if($i != "."){
			counter[i]=counter[i]+1
			SNPinfo[i]=sprintf("%s:%s",SNPinfo[i],sprintf("at %s\t%s->%s\t%s",$2,$4,$5,$i))
		}
	}
	last_contig=$1
}



