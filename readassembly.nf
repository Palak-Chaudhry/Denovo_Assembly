#!/usr/bin/env nextflow
params.outdir = './results/'
// fastp
params.quality_threshold = 30
params.reads = ".raw_data/*{1,2}.fastq.gz"
reads_ch_pairs = Channel.fromFilePairs(params.reads, checkIfExists:true)

log.info """\
   LIST OF PARAMETERS
================================
            GENERAL
Results-folder   : $params.outdir
================================
      INPUT & REFERENCES 
Input-files      : $params.reads
================================
          FASTP
quality threshold: $params.quality_threshold
================================
          SKESA
================================
"""

process READTRIM {
    publishDir "$params.outdir/trim/", mode: 'copy', overwrite: true

    input:
    tuple val(sample), path(reads)

    output:
    tuple val("${sample}"), path("${sample}*.fq.gz"), emit: trim_fq

    script:
    """
    fastp -i ${reads[0]} -I ${reads[1]} -o ${sample}_R1.fq.gz -O ${sample}_R2.fq.gz -3 -M 30 
    """
}

process READASSEMBLY {
    publishDir "$params.outdir/asm/", mode: 'copy', overwrite: true

    input:
    tuple val(sample), path(reads)

    output:
    path "${sample}*.fna", emit: skesa

    script:
    """
    skesa --reads ${reads[0]} ${reads[1]} --contigs_out ${sample}_skesa.fna 
    
    """
}

workflow {
    READTRIM(reads_ch_pairs)
    results = READASSEMBLY(READTRIM.out.trim_fq)
    results.view()
}

// trimmomatic PE ${reads[0]} ${reads[1]} ${sample}_1_P.fq ${sample}_1_U.fq ${sample}_2_P.fq ${sample}_2_U.fq $params.slidingwindow $params.avgqual 
// spades -o ${sample}.fna -1 ${reads[0]} -2 ${reads[1]} -m 10