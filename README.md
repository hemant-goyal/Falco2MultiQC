# Falco2MultiQC 🦅 -> 📊

A lightweight bash wrapper that fixes [Falco](https://github.com/smithlabcode/falco) output files so they can be seamlessly parsed by [MultiQC](https://multiqc.info/).

## 🚨 The Problem
Falco is an incredibly fast, drop-in replacement for FastQC. However, MultiQC currently fails to parse Falco's output because it looks for specific FastQC headers and Unix-style line endings. If you run MultiQC on raw Falco outputs, you will likely get:
> `multiqc | No analysis results found. Cleaning up…`

## 🛠️ The Solution
This script acts as a bridge. It takes your Falco outputs, safely copies them, removes Windows-style `\r\n` line endings, and spoofs the `##Falco` headers to mimic `FastQC v0.11.9`. It also structures the output directories exactly how MultiQC expects them.

## 🚀 Usage

### 1. Installation
Clone the repository and make the script executable. 

```bash
git clone https://github.com/hemant-goyal/Falco2MultiQC.git
cd Falco2MultiQC
chmod +x falco2multiqc.sh
(Pro-tip: You can move this script to your ~/bin or add it to your $PATH so you can call it from anywhere without typing the full path!)

🍿 Option A: The "Lazy" Method (Easiest)
If your terminal is already sitting inside the folder full of your raw Falco results, just run the script blindly. It will automatically scan the current folder and build a new directory for you.

Bash
# 1. Run the script (defaults to creating a folder called './multiqc_ready')
/path/to/falco2multiqc.sh

# 2. Fire up MultiQC on the newly created folder
multiqc ./multiqc_ready
⚙️ Option B: The "Strict Pipeline" Method (Best for automation)
If you are writing a bash script or a Nextflow/Snakemake pipeline, you want to be explicit. Tell the wrapper exactly where the raw files are (-i) and where to put the fixed files (-o).

Bash
# 1. Convert the files from Input (A) to Output (B)
/path/to/falco2multiqc.sh -i /path/to/raw_falco_results -o /path/to/fixed_results

# 2. Run MultiQC on the target directory
multiqc /path/to/fixed_results



