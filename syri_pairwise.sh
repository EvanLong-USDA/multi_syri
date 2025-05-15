#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=48g
#SBATCH --time=8:00:00
#SBATCH --job-name=syri
#SBATCH --output=jobname.out.%j
#SBATCH --partition=short
threads=4
echo $thisDir
eval "$(conda shell.bash hook)"
conda activate minimap2
Genome_name=`basename $1`
Reference=`basename $2`
Chromosome_list=$3
pathtorepo=$4
outputDir=$5

cd $pathtorepo
pwd

#Make repo
mkdir -p $outputDir/${Genome_name}_vs_$Reference
cd $outputDir/${Genome_name}_vs_$Reference
echo $1

#Get only Chromosome fastas for query and Ref
seqtk subseq $1 $Chromosome_list  > Query.fa
seqtk subseq $2 $Chromosome_list  > Ref.fa

#Index
samtools faidx Query.fa
samtools faidx Ref.fa

#Get Chromosome Lengths
cut -f 1-2 Query.fa.fai > ${Genome_name}.chrlen
cut -f 1-2 Ref.fa.fai > ${Reference}.chrlen

#
###1. Run SyRi
##
echo "minimap2 -a -x asm5 --eqx -t $threads Ref.fa Query.fa  > $Genome_name'vs'$Reference'.sam'"
minimap2 -ax asm5 --eqx -t $threads Ref.fa Query.fa  > $Genome_name'vs'$Reference'.sam'
conda activate syri
syri -c $Genome_name"vs"$Reference".sam" -r Ref.fa -q Query.fa -k -F S --prefix ${Genome_name}_vs_$Reference"."
perl -ne 'chomp;if( />(.*)/){$head = $1; $i=0; next};@a=split("",$_); foreach(@a){$i++; if($_ eq "N" && $s ==0 ){$z=$i-1; print "$head\t$z"; $s =1}elsif($s==1 && $_ ne "N"){$j=$i-1;print "\t$j\n";$s=0}}' Query.fa | awk -v OFS="\t" -v awkvar=$Genome_name '{print $1,$2,$3,awkvar,"mt:v;mc:black;ms:1;tp:0.02;ts:8;tf:Droid Sans;tc:black"}' > ${Genome_name}_breakpoints.bed
perl -ne 'chomp;if( />(.*)/){$head = $1; $i=0; next};@a=split("",$_); foreach(@a){$i++; if($_ eq "N" && $s ==0 ){$z=$i-1; print "$head\t$z"; $s =1}elsif($s==1 && $_ ne "N"){$j=$i-1;print "\t$j\n";$s=0}}' Ref.fa | awk -v OFS="\t" -v awkvar=$Genome_name '{print $1,$2,$3,awkvar,"mt:v;mc:black;ms:1;tp:0.02;ts:8;tf:Droid Sans;tc:black"}' > ${Reference}_breakpoints.bed

