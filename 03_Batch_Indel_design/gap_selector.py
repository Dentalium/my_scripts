"""
分析lastz输出的paf文件，输出所有indel的信息和相对ref的坐标
测试中
"""
import re, sys, argparse

align_type="-"
min_gap=15

class MafBlock:
    '''
    一个alignment block中的一条序列
    '''
    def __init__(self,inputlist) -> None:
        # list: 0: name; 1: start; 2: lenth; 3: seq; 4: strand
        self.name=inputlist[0]
        self.start=int(inputlist[1])+1
        self.lenth=int(inputlist[2])
        self.end=self.start+self.lenth-1
        self.seq=inputlist[3]
        self.strand=inputlist[4]
    
    def print_info(self,file):
        print(f">{self.name}\t{self.start}\t{self.end}\t{self.lenth}\t{self.strand}",file=file)
    
    def print_seq(self,file):
        print(f"{self.seq}",file=file)

# 读取所有比对
# 嵌套列表，[0]为ref，[1]为query
all_blocks=[]

with open("../000320vsVada.maf","r") as file:
    for i in file:
        i=i.rstrip()
        if i.startswith("a"):
            flag=2
        if i.startswith("s"):
            if flag==2:
                #print([re.split(" +", i)[indx] for indx in [1,2,3,6,4]])
                all_blocks.append([MafBlock([re.split(" +", i)[indx] for indx in [1,2,3,6,4]])])
            elif flag==1:
                all_blocks[-1].append(MafBlock([re.split(" +", i)[indx] for indx in [1,2,3,6,4]]))
            flag-=1

# 保留特定方向
filtered_blocks=[]
for i in all_blocks:
    if i[1].strand == align_type:
        filtered_blocks.append(i)

#sorted_blocks = sorted(filtered_blocks, key=lambda x: x[0].lenth, reverse=True)

# 输出当前信息
#with open(f"{filename}/{filename}.log","w") as file:
#    file.write(f"Region border: {region_border[0]}-{region_border[1]}\n")
#    file.write(f"Number of results: {result_number}\n")
#    file.write(f"Minimum gap length: {min_gap}\n")

# 打开报告
with open("report.txt","w") as report:
    # 报告头
    report.write("#id\tno\tstart\tend\tlength\tstart_ref\n")
    # 遍历每一个符合要求的alignment block
    for seq_num,this_block in enumerate(filtered_blocks):
        # alignment block的名称
        seqname=f"block_{seq_num}"

        # 分别输出alignmentblock
        with open(f"alignments/{seqname}.fa","w") as file:
            for i in range(2):
                this_block[i].print_info(file)
                this_block[i].print_seq(file)

        # 输出报告，记录
        # gap序号
        gap_counter=1
        # 计位
        counter=0
        # 计长度
        gap_length=0
        ref_total_gap_length=0
        # reference起始点
        ref_start=this_block[0].start

        for j,k in zip(this_block[0].seq, this_block[1].seq):
            counter+=1
            # 记录ref deletion总长度
            if j=="-":
                ref_total_gap_length+=1

            if j=="-" or k=="-":
                gap_length+=1
            elif not gap_length==0:
                if gap_length>=min_gap:
                    report.write(f"{seqname}\t{gap_counter}\t{counter-gap_length}\t{counter-1}\t{gap_length}\t{counter-ref_total_gap_length+ref_start-1}\n")
                    gap_counter+=1
                gap_length=0









