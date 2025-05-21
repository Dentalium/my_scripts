blastdb="./blastdb/sumup.bp.p_ctg"

mkdir -p blastout/

for file in $(ls seqextr/)
do
	blastn -db ${blastdb} -query seqextr/${file} -outfmt 7 -out blastout/${file}.blast.txt
done
