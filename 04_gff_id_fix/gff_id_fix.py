"""
修复基因组序列名称和注释文件中的染色体名称不一致的问题
需要一个id对应表，例如：
RDRW01000001.1 Puccinia hordei isolate 560 utg1, whole genome shotgun sequence
其中RDRW01000001.1是需要保留的名称，utg1是需要替换的名称
"""

fa_id="fasta_id_list.txt"
gff_input="genes.gff"
gff_out="../genes.fixed.gff"

fa_id_dict={}

with open(fa_id) as f:
    for i in f:
        thisline=i.split(sep=" ")
        id_old=thisline[5].rstrip(",")
        id_new=thisline[0]

        fa_id_dict[id_old]=id_new

with open(gff_input) as src, open(gff_out, "w") as dst:
    for i in src:
        line_split=i.rstrip().split(sep="\t")
        try:
            line_split[0]=fa_id_dict[line_split[0]]
        except:
            print(f"{line_split[0]} not included!")
        dst.write("\t".join(line_split)+"\n")

