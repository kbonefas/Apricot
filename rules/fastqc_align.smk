ALL.append(expand(OUTPUT_DIR + '/07-fastqc_align/{sample}_fastqc.html',
                  sample=config['samples']))

rule fastqc_align:
    input:
        OUTPUT_DIR + '/06-umi_tools_dedup/{sample}.genome.umi_tools_dedup.bam',
    output:
        OUTPUT_DIR + '/07-fastqc_align/{sample}_fastqc.html',
    log:
        OUTPUT_DIR + '/07-fastqc_align/.log/{sample}.fastqc_align.log'
    benchmark:
        OUTPUT_DIR + '/benchmarks/fastqc_align.{sample}.benchmark.txt'
    params:
        symlink = OUTPUT_DIR + '/07-fastqc_align/{sample}.bam',
        fastqc_dir= OUTPUT_DIR+ '/07-fastqc_align/',
    shell: '''(
ln -fsr {input} {params.symlink}
fastqc {params.symlink} -o {params.fastqc_dir}
) 2>&1 | tee {log}'''
