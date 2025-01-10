---
title: 'NGPINT_V2'
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

NGPINT is a python based pipeline implementation of various bioinformatic software to identify candidate PPIs from Y2H assays NGIS data.Yeast two-hybrid (Y2H) is a powerful molecular technique to mine protein-protein interactions (PPIs). In order to improve the throughput of the assay to mine a higher number of interactions per assay Y2H has been coupled with next generation sequencing (NGS), a method called next-generation interaction screening (NGIS). As the NGIS is developed, appropriate software to process the data and obtain useful biological informaiton from it is crucial for the PPI mining success. NGPINT is fully adapted to these type of data by identifying prey sequences circumventing the challenges of identifying prey interacting fragments and quantifying prey abundances in a high throughput Y2H assay. By providing a reference genome, NGS data in fastq format, and, optionally, a transcriptome reference, NGPINT can process data from any organism. The novelty of NGPINT to PPI studies is its algorithms to detect fusion reads between the prey and the vector with high confidence, enabeling the acurate identification of prey interaction fragments for cloning and binary Y2H conformation. This allows for much more data to be recovered from NGIS sets, and therefore more developed functional interaction networks.

# Statement of need

NGPINT orchestrates a diverse set of software. A common issue with these types of programs, ones having dependencies on third-party development and maintenance, is compatibility. NGPINT has not been an exception to these difficulties. After it's initial development, despite providing an important scientific resource, NGPINT has been hindered in its adoption into analysis methods for PPI studies. In this release we have constructed container images hosted on both Sylabs Singularity Container Services and Dockerhub, as well as a dockerfile within the NGPINT_V2 repository to provide a mutable set of instructions to reconstruct or edit the workable environment. Providing prebuilt containers for NGPINT solves two of the largest usability issues for the software; 1. it provides a method that doesn't require additional installation or setup, 2. it allows the software to be used, practically, universally across any operating system, where it originally was only able to run on Unix-based machines. This version of the software should provide a more user-friendly experience adopting NGPINT into workflows and provide out-of-the-box avilability for high-throughput computing clusters and cloud-computing services.

# Code Design

The containerized versions of the software are designed to use the program, essentially, as the original software was designed to be used from the command-line. The only difference is the use of the container software:

```
docker pull schuylerds/ngpint
```

And then it can be run through Docker:

```
docker run schuylerds/ngpint
```
```
docker run schuylerds/ngpint -a sample_metadata.csv
```

similarly with Singularity:
```
singularity pull ngpint.sif library://schuyler/ngpint/ngpint
```

And then it can be run through Docker:

```
singularity exec ../ngpint.sif ngpint -a metadata_from_developers.csv
```

# Acknowledgements

# References

