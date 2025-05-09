for file in $(ls seqextr/)
do
	blastn -db blastdb/Vada -query seqextr/${file} -outfmt 7 -out blastout/${file}.blast.txt
done
