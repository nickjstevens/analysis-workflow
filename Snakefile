configfile: "config.yaml"

rule all:
    input:
        expand("models/{loadcase}-post.out", loadcase=config["loadcases"]),
        "models/report.html",
        'models/dag.png'

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
        rm $(snakemake --summary | tail -n+2 | cut -f1)
        """

rule report:
    input:
        FILELIST = expand("models/{loadcase}-post.out", loadcase=config["loadcases"]),
        DAG = 'models/dag.png'
    output:
        "models/report.html"
    run:
        from snakemake.utils import report
        report("""
        An example report by Nick Stevens, Tor Engineering Ltd.
        =======================================================
        Test report goes here. Author is **Nick Stevens**.

        Inline math example: :math:`\sum_{{j \in E}} t_j \leq I`.

        The Directed Acylic Graph (DAG) of the output is shown below:
        
        .. image:: dag.png
        
        Link to the image file: DAG_

        Example of a block of math text:

        .. math::

            |cq_{{0ctrl}}^i - cq_{{nt}}^i| > 0.5

        """, output[0], metadata="Nick Stevens (nick@tor-eng.com)", **input)
