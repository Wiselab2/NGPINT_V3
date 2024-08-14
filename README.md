# NGPINT_V3

Welcome to the latest version of NGPINT (NGPINT_V3)

NGPINT is a software that process Yeast two-hybrid (Y2H) assays, combined with next-generation sequencing (NGS) data. It has driven significant advancements in analyzing protein-protein interactions (PPIs). The NGPINT pipeline, our Python-based bioinformatics tool, processes Y2H-NGS data to identify and quantify potential PPIs by examining both total and fusion read abundances. 

When paired with the companion software Y2H-SCORES (https://github.com/Wiselab2/Y2H-SCORES), NGPINT generates ranking scores to predict high-confidence interactions.

While NGPINT has proven to be a powerful research tool, its usability was previously limited by compatibility issues due to numerous dependencies. To address these challenges and enhance both usability and accessibility, we're excited to introduce NGPINT_V3. This version features a containerized implementation of NGPINT_V2 (https://github.com/Wiselab2/NGPINT_V2) using Singularity and Docker, which ensures compatibility across virtually any operating system and computing environment. The update simplifies dependencies and provides container images hosted on Sylabs and Dockerhub, making it easier to adopt and integrate NGPINT into high-throughput and cloud-computing workflows. 

Dockerhub container: https://hub.docker.com/r/schuylerds/ngpint
Sylabs container: https://cloud.sylabs.io/library/schuyler/ngpint/ngpint

## Instructions

### Docker

To start, pull the container

`docker pull schuylerds/ngpint`

Then, mount all the inputs to run the software, inlcuding:
1) Your working directory into the docker image (this is where the outputs will be placed)
2) Your data folder into the docker, where your fastq files are
3) Your metadata file to pass to NGPINT
if other necessary files are located 

The `/app` directory is the working directory of the NGPNIT container. Anything mounted here will be included in the mounted working directory. An example of the commands would look like:

`docker run ^
    -v C:\Users\scientist\wrkdir:/app/ ^
    -v C:\Users\scientist\NGPINT_V2\example:/data ^
    -v C:\Users\scientist\NGPINT_V2\metadata_from_developers.csv:/metadata_from_developers.csv ^
    schuylerds/ngpint ngpint -a /metadata_from_developers.csv`


### Singularity

singularity works on metal. It does not need filesystem mounts as Docker does. To run NGPINT using singularity, pull the SIF from the Sylabs repository.

`singularity pull ngpint.sif library://schuyler/ngpint/ngpint`

Then run the program using

`singularity exec ngpint.sif ngpint -a metadata_from_developers.csv`
