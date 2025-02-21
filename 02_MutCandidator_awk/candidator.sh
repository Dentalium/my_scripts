#!/bin/bash

set -e
set -u
set -o pipefail

# 注意：草稿阶段，待完善
# 暂时只能读取vcf

if [ "$1" == "-h" ]
then
        echo -e "Usage: `basename $0`\n\t<-w work_path>"
	echo -e "\t-i Input sorted bcf/vcf"
        echo -e "\t-n Minimum number of mutants to report a contig. Default is 2"
        echo -e "\t-c Minimum coverage for position to be regarded. Default is 10"
        echo -e "\t-a Maximum reference allele frequency of a SNP to be reported. Default is 0.01"
        echo -e "\t-z Number mutant lines that are allowed to have SNV in same position. Default is 2\n"
        echo 'This script is to identify candidate contigs with sorted vcf/bcf files produced by minipileup & bcftools.'
	exit 0
fi

work_path=.
paran=2
parac=10
paraa=0.01
paraz=2
param=0
script_path=$(dirname "$0")

while getopts w:i:n:c:a:z:m: opt
do
        case "${opt}" in
                w) work_path=${OPTARG};;
		i) input=${OPTARG};;
		n) paran=${OPTARG};;
                c) parac=${OPTARG};;
                a) paraa=${OPTARG};;
                z) paraz=${OPTARG};;
		m) param=${OPTARG};;
        esac
done

# filter SNPs
if [ -e ${work_path}/$(basename ${input}).a${paraa}c${parac}z${paraz}.filter.vcf  ]
then
	echo "${work_path}/$(basename ${input}).a${paraa}c${parac}z${paraz}.filter.vcf already exists!"
else
	awk -v paraa=${paraa} -v parac=${parac} -v paraz=${paraz} \
                -f ${script_path}/filter_snp.awk \
                ${input} \
                > ${work_path}/$(basename ${input}).a${paraa}c${parac}z${paraz}.filter.vcf
fi

# select candidate contigs
awk -v paran=${paran} -v param=${param}\
	-f ${script_path}/select_mutant.awk \
	${work_path}/$(basename ${input}).a${paraa}c${parac}z${paraz}.filter.vcf \
	> ${work_path}/$(basename ${input}).n${paran}a${paraa}c${parac}z${paraz}m${param}.report.txt


