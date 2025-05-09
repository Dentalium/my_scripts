"""
将plink输出的距离矩阵转换为phylip-format
"""
import gzip

dist_in="plink.dist.gz"
id_in="plink.dist.id"
output="dist.phylip"

id_list=[]
with open(id_in) as f:
    for i in f:
        i=i.rstrip().split("\t")[1]
        # 样本名必须是10个字符
        if len(i) >=10:
            i=i[0:10]
        else:
            i=i+" "*(10-len(i))
        id_list.append(i)

id_num=len(id_list)

with open(output, "w") as dst, gzip.open(dist_in, "rt") as src:
    dst.write(f"\t{id_num}\n")
    for i,v in enumerate(src):
        dst.write(f"{id_list[i]}\t{v}")
