#!/bin/bash
#SBATCH --job-name=fastp_all
#SBATCH --time=2-00:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=8
#SBATCH --partition=all
#SBATCH -w omics-cn003
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

set -euo pipefail

cd /scratch/14993988/fmt_fastp

mkdir -p fmt_fastp_trimmed

for R1 in SRR/*_1.fastq.gz SRA/*_1.fastq.gz;
do 
[ -e "$R1" ] || continue

    PREFIX=${R1%_1.fastq.gz}
    SAMPLE=$(basename "$PREFIX")
    R2="${PREFIX}_2.fastq.gz"

    echo "Processing $SAMPLE"

    fastp \
      --in1 "$R1" \
      --in2 "$R2" \
      --out1 "fmt_fastp_trimmed/${SAMPLE}_R1.trimmed.fastq.gz" \
      --out2 "fmt_fastp_trimmed/${SAMPLE}_R2.trimmed.fastq.gz" \
      --detect_adapter_for_pe \
      --thread 8 \
      --html "fmt_fastp_trimmed/${SAMPLE}_fastp.html" \
      --json "fmt_fastp_trimmed/${SAMPLE}_fastp.json"

    echo "Finished $SAMPLE"
done

echo "ALL DONE"
