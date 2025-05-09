import primer3
import pandas
import argparse

"""
官网：https://github.com/primer3-org/primer3?tab=readme-ov-file
"""

# 已手动修改产物长度、扩增区域等设置

parser=argparse.ArgumentParser(description="Batch primer design with primer3\nVisit https://primer3.org/manual.html for manual.")

parser.add_argument("-i",required=True,help="Templates in fasta format.")
parser.add_argument("-c",default="",help="Configuration file for global arguments. Format: Key=Value.")
parser.add_argument("-o",required=True,help="Output report.")
parser.add_argument("-n",default=0,type=int,help="Number of primer paires to be output per template.")

args=parser.parse_args()

template=args.i
config=args.c
output=args.o
primer_num=args.n

if config:
    global_args={}
    with open(config) as f:
        for i in f:
            k,v=i.rstrip().split("=")
            global_args[k]=eval(v)
else:
    global_args = {
            'PRIMER_NUM_RETURN': 4,
    #        'PRIMER_OPT_SIZE': 23,
    #        'PRIMER_MIN_SIZE': 20,
    #        'PRIMER_MAX_SIZE': 25,
    #        'PRIMER_OPT_TM': 59.0,
    #        'PRIMER_MIN_TM': 57.0,
    #        'PRIMER_MAX_TM': 61.0,
    #        'PRIMER_MIN_GC': 40.0,
    #        'PRIMER_MAX_GC': 60.0,
    #        'PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT': 1,
    #        'PRIMER_MAX_POLY_X': 100,
    #        'PRIMER_INTERNAL_MAX_POLY_X': 100,
    #        'PRIMER_SALT_MONOVALENT': 50.0,
    #        'PRIMER_DNA_CONC': 50.0,
    #        'PRIMER_MAX_NS_ACCEPTED': 0,
    #        'PRIMER_MAX_SELF_ANY': 12,
    #        'PRIMER_MAX_SELF_END': 8,
    #        'PRIMER_PAIR_MAX_COMPL_ANY': 12,
    #        'PRIMER_PAIR_MAX_COMPL_END': 8,
            'PRIMER_PRODUCT_SIZE_RANGE': [100,250],
    #        'PRIMER_GC_CLAMP': 1
    }

if primer_num:
    global_args["PRIMER_NUM_RETURN"]=args.n

## function of read fasta
def readfasta(lines):
    seq = []
    index = []
    seqplast = ""
    numlines = 0
    for i in lines:
        i=i.rstrip()
        if ">" in i:
            index.append(i.replace(">", ""))
            seq.append(seqplast)
            seqplast = ""
            numlines += 1
        else:
            seqplast = seqplast + i
            numlines += 1
        if numlines == len(lines):
            seq.append(seqplast)
    seq = seq[1:]
    return index, seq

## read fasta
with open(template) as f:
    lines = f.readlines()
    (index, seq) = readfasta(lines)

## primer finder, dic -> datafrme
primer_df = pandas.DataFrame()
for i in range(len(index)):
    seq_args = {
        'SEQUENCE_ID': str(index[i]),
        'SEQUENCE_TEMPLATE': str(seq[i]),
        'SEQUENCE_TARGET': [150, 101],
        'SEQUENCE_INCLUDED_REGION': [0, len(seq[i])-1]
    }
    GeneID = str(index[i])

    primer3_result = primer3.bindings.design_primers(seq_args, global_args)

    ## change dic
    primer3_result_table_dict = {}
    for j in range(primer3_result["PRIMER_PAIR_NUM_RETURNED"]):
        primer_id = str(j)
        for key in primer3_result:
            if primer_id in key:
                info_tag = key.replace("_" + primer_id, "")
                try:
                        primer3_result_table_dict[info_tag]
                except:
                    primer3_result_table_dict[info_tag] = []
                finally:
                    primer3_result_table_dict[info_tag].append(primer3_result[key])

    ## append dataframe
    df_index = []
    for m in range(primer3_result["PRIMER_PAIR_NUM_RETURNED"]):
        df_index.append(seq_args['SEQUENCE_ID'] + "_" + str(m + 1))
    primer3_result_df = pandas.DataFrame(primer3_result_table_dict, index=df_index)
    primer_df = pandas.concat([primer_df,primer3_result_df])

primer_df.to_csv(output, sep='\t')
