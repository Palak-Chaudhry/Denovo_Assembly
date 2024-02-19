# Nextflow Pipeline for bacterial genome read cleaning and denovo gene assembly

## Description
This Nextflow pipeline performs read trimming using Fastp and subsequent assembly using Skesa. The pipeline takes raw paired-end fastq files as input, trims them based on the specified quality threshold using Fastp, and then assembles the trimmed reads using Skesa. The results are organized and stored in the specified output directory.

### Get data

You can find the data in the `raw_data` folder. This is just a small sample paired end read from WGS of Acinetobacter Scipio phage.

### Running the Pipeline

1. Clone the repository:

   ```bash
   git clone https://github.com/your_username/your_repository.git
   cd your_repository
   ```
2. Make sure Fastp and Skesa are installed and accessible in your $PATH.
3. Edit the parameters in the script or provide them dynamically:

- `params.outdir`: Output directory for storing results. (default ./results/)
- `params.quality_threshold`: Quality threshold for read trimming. (default 30)
- `params.reads`: Path to raw paired-end fastq files (wildcard allowed).

4. Run the pipeline using Nextflow:

   ```bash
   nextflow readassembly.nf --reads {some/path/*{1,2}.fq.gz} --outdir {your/output/dir/} --quality_threshold 30
   ```
### Results

- You will find the results in `your/output/dir/`. 
- The trimmed reads will be available in `your/output/dir/trim/`.
- The assembled fna files will be available in `your/output/dir/asm/`.

