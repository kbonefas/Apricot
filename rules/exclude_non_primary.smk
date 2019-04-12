# TODO: temporarily stubbed this in to force rule to run, remove when downstream inputs adjusted
ALL.append(expand(OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.{type}.exclude_non_primary.bam.bai',
                  sample=config['samples'],
                  type=['genome', 'transcript']))

rule exclude_non_primary:
    '''
    TODO: Simplify to remove duplication between genome and transcript.
    TODO: Break flagstat and index creation into separate rules?
    '''
    input:
        genome_bam = OUTPUT_DIR + '/03-rsem_star_align/{sample}.STAR.genome.bam',
        transcript_bam = OUTPUT_DIR + '/03-rsem_star_align/{sample}.transcript.bam',
    output:
        genome_bam = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.genome.exclude_non_primary.bam',
        genome_bai = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.genome.exclude_non_primary.bam.bai',
        genome_flagstat = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.genome.exclude_non_primary.flagstat',
        transcript_bam = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.transcript.exclude_non_primary.bam',
        transcript_bai = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.transcript.exclude_non_primary.bam.bai',
        transcript_flagstat = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.transcript.exclude_non_primary.flagstat',
    log:
        OUTPUT_DIR + '/04A-exclude_non_primary/.log/{sample}.exclude_non_primary.log'
    benchmark:
        OUTPUT_DIR + '/benchmarks/exclude_non_primary.{sample}.txt'
    params:
        genome_filtered = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.genome.filtered.bam',
        transcript_filtered = OUTPUT_DIR + '/04A-exclude_non_primary/{sample}.transcript.filtered.bam',
    threads:
        12
    shell:'''(
   samtools view \
       -b \
       -F0x900 \
       {input.genome_bam} \
       > {params.genome_filtered}
    samtools sort \
        -@ {threads} \
        -m 1G \
        -o {output.genome_bam} \
        {params.genome_filtered}
    samtools flagstat {output.genome_bam} > {output.genome_flagstat}
    samtools index {output.genome_bam}

    samtools view \
        -b \
        -F0x900 \
        {input.transcript_bam} \
        > {params.transcript_filtered}
    samtools sort \
        -@ {threads} \
        -m 1G \
        -o {output.transcript_bam} \
        {params.transcript_filtered}
    samtools flagstat {output.transcript_bam} > {output.transcript_flagstat}
    samtools index {output.transcript_bam}

    ) 2>&1 | tee {log}'''