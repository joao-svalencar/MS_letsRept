
# MS: *letsRept*: An R interface to the Reptile Database

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16895979.svg)](https://doi.org/10.5281/zenodo.16895979)

**Authors: João Paulo dos Santos Vieira-Alencar, H. Christoph Liedtke, Shai Meiri, Uri Roll, Peter Uetz and Javier Nori**

This repository is a version control for the manuscript to be submitted [Biodiversity Informatics](https://journals.ku.edu/jbi).

Herein we include R scrips, raw-data and outputs of the paper. This repository was created purely to promote full reproductibility in an easy and transparent way. We also hope that our scripts might stimulate and facilitate further analyses with a similar framework.

If you have any questions, please contact JP Vieira-Alencar at: joaopaulo.valencar@gmail.com

## The repository is organized as follow:
  - ms_letsRept.Rproj: R project for the reproductibility of the analyses;
  - data/
      - atlas.csv

  - outputs/
    - figures/
      - Fig_1_180x100.png
      - Fig_2_180x200.png
    - tables/
      - Table S1.csv
      - Table S2.csv

  - R/
    - D_atlasCaseStudy.R
    - S_figure.R

## Data

File `atlas.csv` is a simplified copy of the supplementary material (Table S3) from Nogueira et al. (2019). This file was used just to extract the list of species mapped therein.

## Code

File `D_atlasCaseStudy.R` has the step-by-step nomenclature check as mentioned in the manuscript.

## Figures

Figure 1 is completely reproducible using script `S_figure.R`. The template for figure 2 is available at: [Canva](https://www.canva.com/design/DAGvyZg7ejA/22wiiUURCI9G35vC-eYHrA/edit?utm_content=DAGvyZg7ejA&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

## References
Nogueira, C. C., Argôlo, A. J. S., Arzamendia, V., Azevedo, J. A. R.,
Barbo, F. E., Bérnils, R. S., Bolochio, B. E., Borges-Martins, M., Brasil-Godinho, M.,
Braz, H., Buononato, M. A., Cisneros-Heredia, D. F., Colli, G. R., Costa, H. C.,
Franco, F. L., Giraudo, A., Gonzalez, R. C., Guedes, T., Hoogmed, M. S.,
Marques, O. A. V., Montingelli, G. G., Passos, P., Prudente, A. L. C., Rivas, G. A.,
Sanchez, P. M., Serrano, F. C., Silva, N. J., Strüssmann, C., Vieira-Alencar, J. P. S,
Zaher, H., Sawaya, R. J., & Martins, M. (2019). Atlas of Brazilian Snakes: Verified Point-Locality Maps to Mitigate the Wallacean Shortfall in a Megadiverse Snake Fauna. S. Am. J. Herpetol., 14(sp1), 1–274. <http://dx.doi.org/10.2994/sajh-d-19-00120.1>
