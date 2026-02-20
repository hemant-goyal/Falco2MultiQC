#!/bin/bash

# ==============================================================================
# Falco2MultiQC: A pipeline wrapper to make Falco outputs MultiQC-compatible
# Author: hemant-goyal
# ==============================================================================

# --- Colors ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- Default Variables ---
INPUT_DIR="."
OUTPUT_DIR="./multiqc_ready"

show_help() {
    echo "Usage: $0 [-i input_directory] [-o output_directory]"
    echo ""
    echo "Options:"
    echo "  -i  Directory containing Falco *_fastqc_data.txt files (default: current dir)"
    echo "  -o  Directory to save MultiQC-compatible folders (default: ./multiqc_ready)"
    echo "  -h  Show this help message"
}

# --- Parse Arguments ---
while getopts "i:o:h" opt; do
    case $opt in
        i) INPUT_DIR="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done

# --- Validation ---
if [ ! -d "$INPUT_DIR" ]; then
    print_error "Input directory '$INPUT_DIR' not found."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
print_info "Scanning '$INPUT_DIR' for Falco data files..."

# Find all fastqc_data.txt files (handles potential spaces in filenames)
find "$INPUT_DIR" -maxdepth 1 -name "*_fastqc_data.txt" | while read -r FILE; do
    
    BASENAME=$(basename "$FILE")
    # Extract the sample name by removing the _fastqc_data.txt suffix
    SAMPLE_NAME="${BASENAME%_fastqc_data.txt}"
    
    # MultiQC expects the fastqc_data.txt to be inside a folder named [sample]_fastqc
    TARGET_DIR="$OUTPUT_DIR/${SAMPLE_NAME}_fastqc"
    TARGET_FILE="$TARGET_DIR/fastqc_data.txt"
    
    mkdir -p "$TARGET_DIR"
    cp "$FILE" "$TARGET_FILE"
    
    print_info "Fixing headers for: $SAMPLE_NAME"
    
    # 1. Convert Windows line endings (\r\n) to Unix (\n) using perl
    perl -pi -e 's/\r\n/\n/g' "$TARGET_FILE"
    
    # 2. Spoof the headers to mimic FastQC v0.11.9
    perl -pi -e 's/##Falco/##FastQC/g' "$TARGET_FILE"
    perl -pi -e 's/^##FastQC.*/##FastQC\t0.11.9/' "$TARGET_FILE"

done

# Check if any files were processed
if [ -z "$(ls -A "$OUTPUT_DIR")" ]; then
    print_error "No *_fastqc_data.txt files found in $INPUT_DIR."
    rm -rf "$OUTPUT_DIR"
    exit 1
fi

print_success "All files processed!"
print_success "You can now run: multiqc $OUTPUT_DIR"
