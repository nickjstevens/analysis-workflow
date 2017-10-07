configfile: "config.yaml"

rule all:
    input:
        expand("models/{loadcase}-post.out", loadcase=config["loadcases"])
 
rule run_analysis:
    input:
        geometry = 'models/model.inp',
        ifile = 'models/{loadcase}.inp'
    output:
        'models/{loadcase}.out'
    shell:
        """
        sleep 1
        echo {input.geometry} {input.ifile} > {output}
        """
 
rule post_analysis:
    input:
        'models/{loadcase}.out'
    output:
        'models/{loadcase}-post.out'
    shell:
        """
        sleep 1
        echo Post processing {input} which creates {output} file > {output}
        """
        
rule dag:
    output:
        'models/dag.png'
    shell:
        'snakemake --forceall --dag | dot -Tpng > {output}'

rule clean:
    shell:
        """
        rm -f models/dag.png
        rm -f models/*.out
        """