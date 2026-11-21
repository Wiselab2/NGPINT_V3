---
title: 'NGPINT_V3'
authors:
  - name: Schuyler D. Smith
    orcid: 0000-0001-5720-5611
    equal-contrib: true
    affiliation: 1
  - name: Valeria Velasquez Zapata
    orcid: 
    equal-contrib: true
    affiliation: 1
  - name: Roger Wise
    orcid: 
    affiliation: 1
affiliations:
 - name: 
   index: 1
tags:
  - python
  - yeast two-hybrid
  - Y2H
  - protein-protein interactions
  - PPI
  - NGS
  - NGIS
date: 01 July 2024
bibliography: paper.bib
csl: biomed-central.csl
output:
  pdf_document: default
  html_document:
    df_print: paged
---

# Summary

NGPINT is a Python-based pipeline implementation of various bioinformatic software to identify candidate PPIs from Y2H assays NGIS data. Yeast two-hybrid (Y2H) is a powerful molecular technique to mine protein-protein interactions (PPIs). In order to improve the throughput of the assay to mine a higher number of interactions per assay, Y2H has been coupled with next-generation sequencing (NGS), a method called next-generation interaction screening (NGIS). As NGIS is developed, appropriate software to process the data and obtain useful biological information from it is crucial for PPI mining success. NGPINT is fully adapted to this type of data by identifying prey sequences, circumventing the challenges of identifying prey interacting fragments and quantifying prey abundances in a high-throughput Y2H assay. By providing a reference genome, NGS data in FASTQ format, and, optionally, a transcriptome reference, NGPINT can process data from any organism. The novelty of NGPINT to PPI studies is its algorithms to detect fusion reads between the prey and the vector with high confidence, enabling the accurate identification of prey interaction fragments for cloning and binary Y2H confirmation. This allows for much more data to be recovered from NGIS sets, and therefore more developed functional interaction networks.

# Statement of need

NGPINT orchestrates a diverse set of software. A common issue with these types of programs, ones having dependencies on third-party development and maintenance, is compatibility. NGPINT has not been an exception to these difficulties. After its initial development, despite providing an important scientific resource, NGPINT has been hindered in its adoption into analysis methods for PPI studies. In this release we have constructed container images for both Docker and Apptainer hosted on the GitHub Container Registry (GHCR), as well as a Dockerfile within the `NGPINT_V3` repository to provide a mutable set of instructions to reconstruct or edit the workable environment. Providing prebuilt containers for NGPINT solves two of the largest usability issues for the software: 1. it provides a method that doesn't require additional installation or setup, and 2. it allows the software to be used practically universally across operating systems, where it originally was only able to run on Unix-based machines. This version of the software provides a more user-friendly experience adopting NGPINT into workflows and provides out-of-the-box availability for high-throughput computing clusters and cloud-computing services.

# Code Design

The containerized versions of the software are designed to run NGPINT essentially as the original software was designed to be used from the command line, using either Docker or Apptainer.

## Docker

To start, pull the container image from the GitHub Container Registry (GHCR) and tag it locally as `ngpint`:

```bash
docker pull ghcr.io/wiselab2/ngpint_v3:latest
docker tag ghcr.io/wiselab2/ngpint_v3:latest ngpint
```

The program can then be run inside the container by mounting your local data, output/working directory, and metadata file into the container:

```bash
docker run --rm \
  -v /home/usr/scientist/wrkdir:/work \
  -v /home/usr/scientist/NGPINT_V3/example:/data \
  -v /home/usr/scientist/NGPINT_V3/example/metadata_from_developers.csv:/metadata.csv \
  ngpint -a /metadata.csv
```

Host file paths will vary on Windows machines, but target paths inside the Docker container always use Linux paths. The container's entrypoint already invokes `ngpint`, so arguments such as `-a /metadata.csv` are passed directly after the `ngpint` image tag.

- `docker run --rm`: Runs the container and removes it once execution completes.
- `-v /home/usr/scientist/wrkdir:/work`: Mounts your local output/working directory into `/work` (set `output_directory` in your metadata file to a path inside `/work`, such as `/work/test_output`). Do not mount over `/opt`, which holds the NGPINT installation and dependencies.
- `-v /home/usr/scientist/NGPINT_V3/example:/data`: Mounts the directory containing your FASTQ and reference files.
- `-v /home/usr/scientist/NGPINT_V3/example/metadata_from_developers.csv:/metadata.csv`: Mounts the metadata CSV file passed to `-a`.

If additional files (such as reference genomes or GTF annotations) are stored outside these directories, mount them using `-v /host/path:/container/path` as well. All file paths listed inside the metadata CSV file must use the mounted paths **inside the container** (e.g., `/data/...` and `/work/...`), rather than host paths.

To run the bundled demonstration dataset directly without editing the relative paths in `example/metadata_from_developers.csv`, mount `example/` as `/data` and set it as the container working directory with `-w /data`:

```bash
docker run --rm \
  -v /home/usr/scientist/NGPINT_V3/example:/data \
  -w /data \
  ngpint -a metadata_from_developers.csv
```

## Apptainer

Apptainer runs containers natively in user space and automatically bind-mounts your current working directory and home directory by default, so explicit mounts are typically unnecessary when your inputs and outputs reside within those directories. If your data or reference files are located on another filesystem (such as `/scratch` on an HPC cluster), bind them with `-B /scratch:/scratch`.

Pull the prebuilt Apptainer SIF image from GHCR via ORAS as `ngpint.sif`:

```bash
apptainer pull ngpint.sif oras://ghcr.io/wiselab2/ngpint_v3-sif:latest
```

(Alternatively, Apptainer can pull and convert the OCI/Docker image directly via `apptainer pull ngpint.sif docker://ghcr.io/wiselab2/ngpint_v3:latest`.)

Then run the program from your data directory using `apptainer exec` (or `apptainer run`):

```bash
apptainer exec ngpint.sif ngpint -a metadata_from_developers.csv
```

```bash
apptainer run ngpint.sif -a metadata_from_developers.csv
```

# Acknowledgements

# References


