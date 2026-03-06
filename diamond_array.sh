#!/bin/bash
#SBATCH --job-name=diamond_batch
#SBATCH --time=08:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=all
#SBATCH --array=0-167

# --- 1. Paths ---
# Use the file created in Step 1
DB="/scratch/14993988/fmt_fastp/sporescore_db.dmnd"
IN_DIR="/scratch/14993988/fmt_fastp/fmt_fastp_trimmed"
OUT_DIR="/scratch/14993988/fmt_fastp/fastp.diamond.results"
# Updated to the path you just found!
DIAMOND_EXE="/zfs/omics/software/bin/diamond"

mkdir -p $OUT_DIR

# --- 2. File Selection ---
FILES=($(ls $IN_DIR/*.fastq.gz))
QUERY_FILE=${FILES[$SLURM_ARRAY_TASK_ID]}
FILENAME=$(basename "$QUERY_FILE")
OUTPUT_FILE="${OUT_DIR}/${FILENAME%.fastq.gz}.diamond.tsv"

# --- 3. Run Diamond ---
echo "Task $SLURM_ARRAY_TASK_ID: Processing $FILENAME"

$DIAMOND_EXE blastx \
    --db "$DB" \
    --query "$QUERY_FILE" \
    --out "$OUTPUT_FILE" \
    --outfmt 6 \
    --threads 8 \
    --max-target-seqs 100

echo "Finished $FILENAME"
