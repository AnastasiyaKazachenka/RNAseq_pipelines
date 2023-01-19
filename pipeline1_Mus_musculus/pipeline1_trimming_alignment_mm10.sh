#!/bin/sh

#SBATCH --job-name=alignment
#SBATCH --ntasks=32 #number of cores
#SBATCH --nodes=1 # Ensure that all cores are on one machine 
#SBATCH --time=1-00:05 #time limit of zero requests no limit. Other formats are allowed 
#SBATCH --mem-per-cpu=4096 #memory per core in MB


### sbatch for example as
#sbatch ./pipeline1_trimming_alignment.sh ./fastq/GEO531A1_1.fastq.gz
#parallel 'sbatch ./pipeline1_trimming_alignment.sh {}' :::  ./fastq/*_1.fastq.gz
#trimmomatic does accept gzipped files
#be careful not to use "{}" if the file path contains escape quotes \
#HISAT2 does accept gzipped files

module load Trimmomatic

f="$1"
f1="${f%%_1.fq.gz}"
f2="${f1##*/}" #second fastq from paired end reads


echo "first variable f" "$f"
echo "second variable f1" "$f1"
echo "third variable f2" "$f2"


if [ ! -d "./trimming.logs" ]; then
	mkdir -p "./trimming.logs"
fi

if [ ! -d "./trimmed.reads" ]; then
	mkdir -p "./trimmed.reads"
fi


java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar \
	PE \
	-threads 4 \
	-phred33 \
	"$f" \
	"$f1"_2.fq.gz \
	./trimmed.reads/"$f2"_trimmed_end1.fq \
	/dev/null \
	./trimmed.reads/"$f2"_trimmed_end2.fq \
	/dev/null \
	ILLUMINACLIP:/camp/lab/kassiotisg/working/SCRIPTS/Trimmomatic/Trimmomatic.TruSeq3-PE-2plusuniversal.fa:2:40:10:2:true \
	SLIDINGWINDOW:3:20 \
	MINLEN:35 \
>& ./trimming.logs/"$f2".trim.log


gzip ./trimmed.reads/"$f2"_trimmed_end1.fq
gzip ./trimmed.reads/"$f2"_trimmed_end2.fq



### fastQC to test for successful removal of adapter
ml load FastQC

if [ ! -d "./fastQC" ]; then
	mkdir -p "./fastQC"
fi

fastqc ./trimmed.reads/"$f2"_trimmed_end1.fq.gz -o ./fastQC
fastqc ./trimmed.reads/"$f2"_trimmed_end2.fq.gz -o ./fastQC



### Hisat alignment

module load HISAT2  #in case it was not loaded in environment
module load SAMtools/1.3.1-foss-2016b #in case it was not loaded in environment


if [ ! -d "./sam.files" ]; then
	mkdir -p "./sam.files"
fi

if [ ! -d "./bam.files" ]; then
	mkdir -p "./bam.files"
fi


if [ ! -d "./mapping" ]; then
	mkdir -p "./mapping"
fi


hisat2 -p 8 -q -k 20 --no-unal -x ~/working/SCRIPTS/indexes/hisat2/mm10/mm10 \
-1 ./trimmed.reads/"$f2"_trimmed_end1.fq.gz -2  ./trimmed.reads/"$f2"_trimmed_end2.fq.gz -S ./sam.files/"$f2".sam >> ./mapping/hisat2.mapping."$f2".txt 2>&1  #hisat outputs mapping stats to sterr ..


echo "succesfully finished hisat2 for:" "$fastq"


###sam to bam and sort
samtools view -bS ./sam.files/"$f2".sam \
| samtools sort - -o ./bam.files/"$f2"_k20.bam


### index and remove sam only if index was successful
samtools index ./bam.files/"$f2"_k20.bam && rm ./sam.files/"$f2".sam
