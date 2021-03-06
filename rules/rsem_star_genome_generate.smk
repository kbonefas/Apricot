from os.path import join
_defaultSjdbOverhang = config['sequencing_parameters']['read_length'] - 1
_star_config = config['genome_reference']['star']

rule rsem_star_genome_generate:
    input:
        fasta = REFERENCE_DIR + '/' + config['genome_reference']['fasta'],
        gtf = REFERENCE_DIR + '/' + config['genome_reference']['gtf'],
    output:
        parametersFiles = join(\
                REFERENCE_DIR,
                _star_config['genome_dir'],
                'genomeParameters.txt'
                ),
    log:
        REFERENCE_DIR + '/' + _star_config['genome_dir'] + '/.log/rsem_star_genome_generate.log'
    benchmark:
        OUTPUT_DIR + '/benchmarks/rsem_star_genome_generate.benchmark.txt'
    threads: 12
    params:
        genomeDir = REFERENCE_DIR + '/' + _star_config['genome_dir'],
        sjdbOverhang = _star_config.get('sjdbOverhang', _defaultSjdbOverhang),
    shell: '''
(
STAR_PATH=$(dirname $(which STAR))
rsem-prepare-reference \
    --gtf {input.gtf} \
    --star \
    --star-path $STAR_PATH \
    --star-sjdboverhang {params.sjdbOverhang} \
    -p {threads} \
    {input.fasta} \
    {params.genomeDir}/RSEM_ref
) 2>&1 | tee {log}'''
