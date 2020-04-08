https://scrnaseq-course.cog.sanger.ac.uk/website/index.html

###FASTQC

fastqc -h #help
mkdir fastqc_results
fastqc -o fastqc_results Share/ERR522959_1.fastq Share/ERR522959_2.fastq

#Trimming raw reads
trim_galore -h
mkdir fastqc_trimmed_results
trim_galore --nextera -o fastqc_trimmed_results Share/ERR522959_1.fastq Share/ERR522959_2.fastq

###Demultiplexing

Use perl script Flexible_UMI_Demultiplexing.pl
perl utils/Flexible_UMI_Demultiplexing.pl data/10cells_read1.fq data/10cells_read2.fq "C12U8" data/10cells_barcodes.txt 2 Ex
perl utils/Flexible_FullTranscript_Demultiplexing.pl data/10cells_read1.fq data/10cells_read2.fq "start" 12 data/10cells_barcodes.txt 2 Ex

#Identifying cell-containing droplets/microwells
umi_per_barcode <- read.table("data/droplet_id_example_per_barcode.txt.gz")
truth <- read.delim("data/droplet_id_example_truth.gz", sep=",")


###Using STAR to Align Reads

#to create the index
mkdir indices
mkdir indices/STAR
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir indices/STAR --genomeFastaFiles Share/2000_reference.transcripts.fa

#STAR Alignment
mkdir results
mkdir results/STAR
STAR --runThreadN 4 --genomeDir indices/STAR --readFilesIn Share/ERR522959_1.fastq Share/ERR522959_2.fastq --outFileNamePrefix results/STAR/

#STAR is a reads aligner, whereas Kallisto is a pseudo-aligner (Bray et al. 2016). The main difference between aligners and pseudo-aligners is that whereas aligners map reads to a reference, pseudo-aligners map k-mers to a reference.

###Using Kallisto to Align

#Kallisto index
mkdir indices/Kallisto
kallisto index -i indices/Kallisto/transcripts.idx Share/2000_reference.transcripts.fa

#Kallisto Pseudo Alignment
mkdir results/Kallisto
kallisto pseudo -i indices/Kallisto/transcripts.idx -o results/Kallisto -b batch.txt


