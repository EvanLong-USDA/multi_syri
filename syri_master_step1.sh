FastaList=$1
outputDir=$2
Chromosome_list=$3
pathtorep=`pwd`

mkdir -p $outputDir

#!/bin/bash
prev=""
while read -r line; do
  if [ -n "$prev" ]; then
    sbatch syri_pairwise.sh "$line" "$prev" $Chromosome_list $pathtorep $outputDir
  fi
  prev="$line"
done < $FastaList


cp genomes.txt $outputDir/
cp base.cfg $outputDir/
cp plotsr_options.txt $outputDir/
cat $FastaList | sed "s/.*\///g" | awk -v OFS="\t" '{print $1".chrlen",$1,"ft:cl;lw:1.5"}' >> $outputDir/genomes.txt




