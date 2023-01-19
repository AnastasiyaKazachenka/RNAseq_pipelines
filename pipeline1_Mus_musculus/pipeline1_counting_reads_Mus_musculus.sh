#! /bin/bash

#####################################################

#SBATCH --job-name=feature_counting

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=80G
#SBATCH --time=12:00:00


######################################################


#use 
#sbatch ~/shellscripts/feature_counting_allinone.sh 

### featurecounts
# -B option says to only count reads which have both ends mapped!
# did not use stranded counting (-s)
# -t 2 allows to use two cores

module load Subread/1.5.0-p1-foss-2016b


featureCounts -p -C -B --primary -a ~/working/SCRIPTS/annot.files/mus_musculus/Mus_musculus.GRCm38.90.gtf \
	-o ./raw_gene.counts \
	./bam.files/*.bam >> ./mapping/featurecounts_genes.txt 2>&1

featureCounts -p -C -B -f -T 2	--primary \
	-a ~/working/SCRIPTS/annot.files/GRCm38.78_Dfam2_full.gtf \
	-o ./raw_TE.counts \
	./bam.files/*.bam &> ./mapping/featurecounts_repeatLoci.txt
