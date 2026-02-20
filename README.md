# Falco2MultiQC 🦅 -> 📊

A lightweight bash wrapper that fixes [Falco](https://github.com/smithlabcode/falco) output files so they can be seamlessly parsed by [MultiQC](https://multiqc.info/).

## 🚨 The Problem
Falco is an incredibly fast, drop-in replacement for FastQC. However, MultiQC currently fails to parse Falco's output because it looks for specific FastQC headers and Unix-style line endings. If you run MultiQC on raw Falco outputs, you will likely get:
> `multiqc | No analysis results found. Cleaning up…`

## 🛠️ The Solution
This script acts as a bridge. It takes your Falco outputs, safely copies them, removes Windows-style `\r\n` line endings, and spoofs the `##Falco` headers to mimic `FastQC v0.11.9`. It also structures the output directories exactly how MultiQC expects them.

## 🚀 Usage

**Make it executable:**
```bash
chmod +x falco2multiqc.sh
