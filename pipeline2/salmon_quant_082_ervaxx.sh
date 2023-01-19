#! /bin/bash

#####################################################

#SBATCH --job-name=salmon_quant

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=80G
#SBATCH --time=12:00:00


######################################################


### file input & directory
fullname=$1
#fullname="./datasets/a/b/test_gdc_realn_rehead.bam" #test name


if [ ! -d "./salmon082" ]; then
	mkdir -p "./salmon082"
fi


fullfilename="${fullname##*/}"
indirectory="${fullname%/*}"
subdirectory="${indirectory##*/}"

filename="${fullfilename%_trimmed_end1.fq.gz}"

/camp/project/proj-kassiotisg-ervaxx/working/scripts/bin/salmon-0.8.2/bin/salmon082 quant -p 8 -i /camp/project/proj-kassiotisg-ervaxx/working/countFiles/DiscoverySet_transcriptome_index -l IU --seqBias --gcBias -1 "$fullname" -2 "$indirectory/$filename"_trimmed_end2.fq.gz -o ./salmon082/"$filename"
