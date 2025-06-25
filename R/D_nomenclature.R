# updating nomenclature with letsHerp -------------------------------------

# install the package (GitHub), load it, and view vignettes
devtools::install_github("joao-svalencar/letsHerp", ref="main", force=TRUE)
library(letsHerp)
#browseVignettes("letsHerp")

?herpAdvancedSearch
?herpSearch
?herpSpecies
?herpSplitCheck
?herpSync
?herpSynonyms #check
?herpTidySyn

#load Nogueira et al., (2019) Supp. Mat. Table S3 (georeferenced type localities)
atlas <- read.csv(here::here("data", "raw", "atlas.csv"))
#tz <- read.csv(here::here("data", "raw", "tz_reptiles.csv"))

# Creates a link for all snakes occurring in Brazil according to RDB
snakes_br_link <- herpAdvancedSearch(location="Brazil", higher="snakes") # 450 spp


# Samples each species higher taxa and respective URLs
snakes_br <- herpSpecies(snakes_br_link, taxonomicInfo = FALSE, getLink = TRUE)
snakes_br 


#sort(table(snakes_br$family), decreasing = TRUE) #nine families
#sort(table(snakes_br$genus[snakes_br$family=="Viperidae"]), decreasing = TRUE)

atlas$species <- gsub("\\s{2,}", " ", atlas$species) #cleaning any existing double or more whitespaces from species names
atlas$species <- trimws(gsub("\\s+", " ", atlas$species)) #cleaning any existing leading and trailing whitespaces

# code chunks for the paper
sum(atlas$species %in% snakes_br$species) # only 372 matching nomenclature
review <- atlas$species[which(!atlas$species %in% snakes_br$species)] #39 unmatched names 

snakes_names <- herpSync(review, solveAmbiguity = TRUE)
snakes_names

table(snakes_names$status)
# ambiguous duplicated up_to_date    updated 
#    3          2           1           35

#to check duplicated and ambiguous species:
herpTidySyn(snakes_names, filter = c("duplicated", "ambiguous"))

#write.csv(snakes_names, here::here("outputs", "review.csv"), row.names = FALSE)

# check the matched ones --------------------------------------------------
matched <- atlas$species[which(atlas$species %in% snakes_br$species)]

matched_names <- herpSplitCheck(matched, pubDate = 2019, FALSE)
#write.csv(matched_names, here::here("outputs", "matched.csv"), row.names = FALSE)
matched_names_parallel <- herpSplitCheck(matched, pubDate = 2019)

herpTidySyn(matched_names_parallel, filter = "check_split")


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
head(iucn)

sort(table(iucn$family), decreasing = TRUE)
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
rdb_vipers <- herpSpecies(rdb_vipersLink, taxonomicInfo = TRUE, getLink = TRUE) #405 species

head(rdb_vipers)
sum(iucnVipers$species %in% rdb_vipers$species) # 282

review <- iucnVipers$species[which(!iucnVipers$species %in% rdb_vipers$species)] #32

review <- gsub("\\s{2,}", " ", review) #cleaning any existing double or more whitespaces from species names
review <- trimws(gsub("\\s+", " ", review)) #cleaning any existing leading and trailing whitespaces


system.time(
vipers_ambiguous <- herpSync(review, solveAmbiguity = TRUE, showProgress = FALSE)
)

vipers_ambiguous[-4]

nrow(allReptiles)
nrow(allSynonyms)
nrow(allSynonymsRef)

sort(table(allSynonyms$species), decreasing = TRUE)
allSynonyms$synonyms[allSynonyms$species=="Mediodactylus kotschyi"]

median(as.integer(allReptiles$year))

head(allReptiles)
head(allSynonymsRef)

letsHerp::allReptiles[allReptiles$family == "Sphenodontidae",] 
table(allReptiles$order)

sort(table(allReptiles$order), decreasing = TRUE)
