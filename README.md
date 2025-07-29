
# MS: *letsRept*: An R interface to the Reptile Database

**Researchers involved are: João Paulo dos Santos Vieira-Alencar, H. Christiph Liedtke, Shai Meiri, Uri Roll and Javier Nori**

This repository is a version control for the manuscript to be submitted [Ecological Informatics](https://www.sciencedirect.com/journal/ecological-informatics).

Herein we include R scrips, raw-data and outputs of the paper. This repository was created purely to promote full reproductibility in an easy and transparent way. We also hope that our scripts might stimulate and facilitate further analyses with a similar framework.

If you have any doubt, please contact JP Vieira-Alencar at: joaopaulo.valencar@gmail.com

## Analyses reproducibility

This repository incorporates a package version management system facilitated by the `renv` package, ensuring the proper functionality of all functions utilized in the scripts. To leverage this functionality, execute the following code after initializing the Rproj file:

````
#Install the "renv" package
install.packages("renv")

#Restore versions of the utilized packages
renv::restore()
````

**Important Note:**

The provided code will automatically install the required packages, aligning them with the same versions used during the preparation of the scripts.
This ensures the reproducibility of the analyses. However, the outcome may change in relation to the MS analyses due to reptile nomenclatural changes.

## The repository is organized as follow:
  - ms_letsRept.Rproj: R project for the reproductibility of the analyses;
  - data/
    - processed/
    - raw/
      - atlas.csv
      - squambase.csv
      - repttraits.csv

  - outputs/
    - figures/
    - tables/

  - R/
    - R_data.R: loading objects
    - D_atlasCaseStudy.R
    - D_squambase.R
    - S_figures.R

The goal of ms_letsHerp is to ...

