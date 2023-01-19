Step 1.

Run salmon_quant_082_ervaxx.sh

Usage
parallel 'sbatch $HOME/working/SCRIPTS/scripts/pipeline2/salmon_quant_082_ervaxx.sh {}' ::: ./trimmed.reads/*_trimmed_end1.fq.gz
sbatch $HOME/working/SCRIPTS/scripts/pipeline2/salmon_quant_082_ervaxx.sh ./trimmed.reads/FILE_NAME_trimmed_end1.fq.gz

Uses salmon v 0.8.2 that is kept in ervaxx project folder

Output:
slamon082 directory with salmon output for each RNA-seq experiment


Step 2.

Run make_TPMs_table.sh when all files have been run in step 1

sbatch $HOME/working/SCRIPTS/scripts/pipeline2/make_TPMs_table.sh

Uses R script called make_TPMs_table.R

Output 
TPMs_salmon082.csv  - table with TPM counts
make_TPMs_table.out - executed R code
