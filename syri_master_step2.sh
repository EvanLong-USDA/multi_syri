outputDir=$1
Chromsome_list=$2
thisDir=`pwd`
eval "$(conda shell.bash hook)"
conda activate syri
cd $thisDir
cd $outputDir
cat */*.bed | sort -u > markers.bed
mv */*.out .
mv */*.chrlen .
ls *.out | awk '{print "--sr ",$1,"\\"}' > args.txt
echo "plotsr \\" > plotsr.head
cat plotsr.head args.txt plotsr_options.txt > plotsr.sh
for x in `cat $Chromsome_list`; do sed "s/NUMBER/$x/g" plotsr.sh > plotsr_${x}.sh; bash plotsr_${x}.sh; done
