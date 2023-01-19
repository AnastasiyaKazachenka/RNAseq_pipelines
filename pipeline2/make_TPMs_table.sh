#! /bin/bash

#####################################################

#SBATCH --job-name=tpm_table

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=80G
#SBATCH --time=1-00:05


######################################################


ml purge
#module load R/4.1.2-foss-2021b
module load R/3.3.1-foss-2016b

which R
R CMD BATCH --quiet --no-restore --no-save $HOME/working/SCRIPTS/scripts/pipeline2/make_TPMs_table.R ./make_TPMs_table.out

