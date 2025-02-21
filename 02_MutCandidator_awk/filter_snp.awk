BEGIN{
	OFS="\t"
#	paraa=0.5
#	parac=10
#	paraz=2
}
# 处理header
/^#[^#]/{
	# 简化突变体名称，用samples储存
	for(i=10;i<=NF;i++){
        gsub(/^.*\//,"", $i)
		samples[i]=$i
	}
	samplenum=NF-9
	print
}
# 读取records
# 删除ref为N的位点
$1~/^[^#]/ && $4!="N"{
	# befor用于排除同一位点多数突变体具有的SNP，不一定是有效的
	# after用于排除同一位点多个突变体具有的有效SNP
	beforflag=0
	afterflag=samplenum
	# 分别读取每个sample
	for(i in samples){
		# 读取Info信息
		# infos[1]:allele1; infos[2]:allele2; infos[3]:dp0(ref); infos[4]:dp1(alt1); ...
		split($i,infos,"[/:,]")
		# 统计此位点与ref不一致的SNP数量
		if (infos[1] != $4) {
			beforflag=beforflag+1
		}
		# 计算总深度
		dp=0
		for(j=3; j<=length(infos); j++)
			dp=dp + infos[j]
		# 过滤总深度
		if(dp <= parac){
			$i="."
		}
		# 过滤ref freq
		if(infos[3]/dp >= paraa){
			$i="."
		}
		# 统计此位点有效SNP数量
		if($i==".")
			afterflag=afterflag-1
	}
	# 过滤与ref不一致的突变体（不一定有效SNP）过多的位点，至多30%的突变体
	# 过滤无有效SNP或有效SNP过多（> paraz）的位点
	if(beforflag <= samplenum*0.3 && afterflag > 0 && afterflag <= paraz)
		print
}
