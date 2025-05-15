# multi_syri
A pipeline to streamline the analysis of multiple genome assemblies through SyRI plots.

## Usage

### Step 1: Unzip test data
Before running the pipeline

-make conda environments

-unzip the test dataset

-Change absolute paths in Genome_list.txt 

```bash
for x in `ls testdata/*`; do gunzip $x; done
conda env create -f minimap2.yml
conda env create -f syri.yml
```

Step 2: Run the first script
Execute the syri_master_step1.sh script with the following command:
```bash
bash syri_master_step1.sh Genome_list.txt output1 absolute/path/Chromosome_list.txt
```

Note: The syri_pairwise.sh script is designed to be submitted through SLURM using sbatch within syri_master_step1.sh. If you are not using a SLURM environment, you will need to modify the script accordingly.

Wait until all minimap/syri commands are completed before running th next step


Step 3: Run the second script
Execute the syri_master_step2.sh script with:
```bash
bash syri_master_step2.sh output1 absolute/path/Chromosome_list.txt
```

Requirements

SyRI 

minimap2

seqtk

samtools

SLURM (if using unmodified scripts)


