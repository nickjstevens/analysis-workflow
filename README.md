# analysis-workflow
An example engineering analysis workflow for reproducible results.

## Getting Started
Clone the repository and cd into it.

The workflow is containerised with Docker, so install docker as a prerequisite (my preference is Kitematic for my old mac). Running the workflow in a container means the analysis is self-contained and reproducible. 

The base docker image is a jupyter image which gives you the conda package manager, python and access to jupyter notebooks via the web interface. I like this approach because with a jupter notebook you can explore results easily, plus via the same web interface you can launch a simple terminal, so you can do most things from the browser.

## Analysis Workflow / Pipeline
The workflow uses Snakemake which is an excellent open source python workflow tool. An excellent Snakemake tutorial is here: http://slowkow.com/notes/snakemake-tutorial/.

## Start the Container
You have two options to start the container - docker, or docker-compose. I prefer docker-compose because it is clearer to define everything via the `docker-compose.yaml` file. Make sure you are in the right directory before running the commands below:
 - docker-compose option: `docker-compose up`
 - docker option: `docker run -i -t --name my-jupyter -p 8888:8888 -v $(pwd):/home/jovyan/work jupyter/datascience-notebook start.sh jupyter notebook`

Whichever option you choose the terminal will print the ip address where the jupyter notebook can be accessed, including access to the container with a jupyter notebook terminal. Access the address, which will be something like: http://192.168.99.100:8888/. The `work` folder is mapped to the directory on your local machine, and is the way to share files between the container and your local machine.

## Configure the Snakemake Workflow
Now we need to define the analysis workflow. There is a Snakefile that defines the workflow, in the style of Makefile. See the Snakemake documentation for more information. The simple example here runs and then post-processes a series of loadcases.
Edit `config.yaml`, `environment.yaml` and `Snakefile` as required:
 - `config.yaml` contains the loadcases that you want to run
 - `environment.yaml` contains the packages and environments for the analysis (i.e. the dependencies)
 - `Snakefile` contains the workflow tasks and dependencies

## Create Workflow Environment
From the jupyter notebook launch a terminal (New > Terminal) and run:
`conda env create --name snakemake-env --file environment.yaml`
This creates the environment and installs the dependencies. Now activate the environment:
`source activate snakemake-env`

## Run the Snakemake Workflow
The workflow is now all set up and can be executed:
`snakemake`

To create a DAG of the workflow use:
`snakemake dag` 

And to clean the directories use:
`snakemake clean`

To deactivate the environment when you have finished use:
`source deactivate`

## Archive
Snakemake can be used to archive the workflow:
`snakemake --archive my-workflow.tar.gz`

## Docker Tips
To start a stopped container use `docker start my-jupyter`. Or use the Kitematic GUI (my preference).
To open a terminal in a started container, use `docker exec -it my-jupyter start.sh /bin/bash` or `docker exec -it my-jupyter start.sh jupyter lab`

