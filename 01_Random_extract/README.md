# Random_extract
To extract a subset of long-reads which meets the user-set total length limit.

`Biopython` is required.

Usage: 
```bash
python random_extract.py -i <inputfile> -t <threshold> [-o outputfile] [-s random_seed]
```
This script has been applied in the following paper: https://doi.org/10.1016/j.xplc.2024.101070.
