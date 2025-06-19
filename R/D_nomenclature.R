# updating nomenclature with letsHerp -------------------------------------

# code chunks for the paper
# install the package (CRAN or GitHub), load it, and view vignettes
#install.packages("letsHerp")
devtools::install_github("joao-svalencar/letsHerp", ref="main", force=TRUE)
library(letsHerp)
browseVignettes("letsHerp")

# code chunks for the paper
#load Nogueira et al., (2019) Supp. Mat. Table S3 (georeferenced type localities)
atlas <- read.csv(here::here("data", "raw", "atlas.csv"))

# code chunks for the paper
# Creates a link for all snakes occurring in Brazil according to RDB
snakes_br_link <- herpAdvancedSearch(location="Brazil", higher="snakes") # 450 spp
# Samples each species higher taxa and respective URLs
snakes_br <- herpSpecies(snakes_br_link, taxonomicInfo = FALSE, getLink = TRUE)

sort(table(snakes_br$family), decreasing = TRUE) #nine families
sort(table(snakes_br$genus[snakes_br$family=="Viperidae"]), decreasing = TRUE)

atlas$species <- gsub("\\s{2,}", " ", atlas$species) #cleaning any existing double or more whitespaces from species names
atlas$species <- trimws(gsub("\\s+", " ", atlas$species)) #cleaning any existing leading and trailing whitespaces

# code chunks for the paper
sum(atlas$species %in% snakes_br$species) # only 372 matching nomenclature
review <- atlas$species[which(!atlas$species %in% snakes_br$species)]

#review <- c(review, "Fake name")

snakes_names <- herpSyncParallel(review, solveAmbiguity = TRUE, cores = max(1, parallel::detectCores() - 1))

write.csv(snakes_names[,c(1:3)], here::here("outputs", "review.csv"), row.names = FALSE)

snakes_names[snakes_names$RDB=="check Link", c(1:3)]

snakes_names_new <- herpSyncParallel(review, cores = max(1, parallel::detectCores() - 1))

snakes_names[snakes_names$RDB=="check Link", c(1:3)]
snakes_names_new[snakes_names$RDB=="check Link",c(1:3)]

names(snakes_names)[1] <- "species"

cl <- herpSpecies(snakes_names[snakes_names$species=="Corallus hortulanus","url"], getLink = TRUE,showProgress = FALSE)

herpSynonyms(cl,showProgress = FALSE, getRef = TRUE)

herpSynonyms(snakes_names[snakes_names$species=="Chironius laurenti",],)

cc <- herpSearch("Corallus cookii", ref = TRUE)

cc$References
cc$Comment

# #getting list of synonyms for all Brazilian snakes ----------------------
syn_br <- herpSynonyms(snakes_br) #2537 synonyms
sum(atlas$species %in% syn_br$synonyms) # all 411 species within the synonym list

syn_br_atlas <- syn_br[syn_br$synonyms %in% update$species,]
duplicated(syn_br_atlas)


# iucn example ------------------------------------------------------------
#Boidae
iucnBoidae <- iucn[iucn$family=="Boidae",] #48 species
rdb_boidaeLink <- herpAdvancedSearch(higher= "Boidae")
rdb_boidae <- herpSpecies(rdb_boidaeLink, taxonomicInfo = TRUE, getLink = TRUE) #67 species
rdb_boidae[,c(-7, -8)]

sum(iucnBoidae$species %in% rdb_boidae$species) # 47
sum(!rdb_boidae$species %in% iucnBoidae$species)

rdb_boidae[!rdb_boidae$species %in% iucnBoidae$species,c(-7,-8)]

review <- iucnBoidae$species[which(!iucnBoidae$species %in% rdb_boidae$species)] # Corallus hortulanus
herpSearch(review)
ch <- herpSpecies(herpSearch(review), getLink = TRUE)
herpSynonyms(ch)

boidae_ambiguous <- herpSyncParallel(iucnBoidae$species, solveAmbiguity = FALSE)
boidae_ambiguous[, -4]

# Viperidae ---------------------------------------------------------------
iucnVipers <- iucn[iucn$family=="Viperidae",] #314 species
rdb_vipersLink <- herpAdvancedSearch(higher= "Viperidae")
rdb_vipers <- herpSpecies(rdb_vipersLink, getLink = TRUE) #405 species

sum(iucnVipers$species %in% rdb_vipers$species) # 282

review <- iucnVipers$species[which(!iucnVipers$species %in% rdb_vipers$species)] #32

review <- gsub("\\s{2,}", " ", review) #cleaning any existing double or more whitespaces from species names
review <- trimws(gsub("\\s+", " ", review)) #cleaning any existing leading and trailing whitespaces


vipers_ambiguous <- herpSyncParallel(review[1:10], solveAmbiguity = TRUE)
vipers_ambiguous[,-4]
