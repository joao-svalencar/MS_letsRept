# updating nomenclature with letsHerp -------------------------------------

# install the package (GitHub), load it, and view vignettes
devtools::install_github("joao-svalencar/letsHerp", ref="main", force=TRUE)
library(letsHerp)
browseVignettes("letsHerp")

#load Nogueira et al., (2019) Supp. Mat. Table S3 (georeferenced type localities)
atlas <- read.csv(here::here("data", "raw", "atlas.csv"))

# Creates a link for all snakes occurring in Brazil according to RDB
snakes_br_link <- herpAdvancedSearch(higher = "snakes", location = "Brazil") # 450 spp


# Samples each species higher taxa and respective URLs
snakes_br <- herpSpecies(snakes_br_link, taxonomicInfo = TRUE, getLink = TRUE, cores = 9)
snakes_br

# Exploring higher taxa information
sort(table(snakes_br$family), decreasing = TRUE)
sort(table(snakes_br$genus[snakes_br$family=="Viperidae"]), decreasing = TRUE)

#atlas$species <- gsub("\\s{2,}", " ", atlas$species) #cleaning any existing double or more white spaces from species names
#atlas$species <- trimws(gsub("\\s+", " ", atlas$species)) #cleaning any existing leading and trailing white spaces

sum(atlas$species %in% snakes_br$species) # only 372 matching nomenclature
review <- atlas$species[which(!atlas$species %in% snakes_br$species)] #39 unmatched names 

snakes_names <- herpSync(review, solveAmbiguity = TRUE, cores = 9)
snakes_names

table(snakes_names$status)
# ambiguous duplicated up_to_date    updated 
#    3          2           1           33

#to check duplicated and ambiguous species:
herpTidySyn(snakes_names, filter = c("duplicated", "ambiguous")) #Table 3

herpSearch("Corallus cookii")
herpSearch("Corallus hortulana")

herpSearch("Adelphostigma occipitalis")
herpSearch("Adelphostigma quadriocellata")
herpSearch("Eutrachelophis papilio")

herpSearch("Tachymenis ocellata")
herpSearch("Tachymenis trigonatus")

herpSearch("Liotyphlops ternetzii")

write.csv(snakes_names, here::here("outputs", "review.csv"), row.names = FALSE)

# check for species taxonomic split ---------------------------------------
matched <- atlas$species[which(atlas$species %in% snakes_br$species)]

split_check <- herpSplitCheck(matched, pubDate = 2019, cores = 9)

table(split_check$status)
#check_split: 19; checked: 2; up_to_date: 351

#to check check_split species:
herpTidySyn(split_check, filter = c("check_split", "checked"))

#Atractus
herpSpecies(herpAdvancedSearch(synonym = "Atractus albuquerquei"), taxonomicInfo = T)
herpSearch("Atractus stygius")

herpSpecies(herpAdvancedSearch(synonym = "Atractus badius"), taxonomicInfo = T)
herpSearch("Atractus akerios")

herpSpecies(herpAdvancedSearch(synonym = "Atractus major"), taxonomicInfo = T)
herpSearch("Atractus nawa", getRef = T)

herpSpecies(herpAdvancedSearch(synonym = "Atractus snethlageae"), taxonomicInfo = T)
herpSearch("Atractus snethlageae", getRef = T)

#Chironius
herpSpecies(herpAdvancedSearch(synonym = "Chironius bicarinatus"), taxonomicInfo = T)
herpSearch("Chironius dracomaris", getRef = T)
herpSearch("Chironius gouveai", getRef = T)


herpSpecies(herpAdvancedSearch(synonym = "Chironius carinatus"), taxonomicInfo = T)
herpSearch("Chironius nigelnoriegai", getRef = T)

#Oxybelis aeneus
herpSpecies(herpAdvancedSearch(synonym = "Oxybelis aeneus"), taxonomicInfo = T)
herpSearch("Oxybelis inkaterra", getRef = T)
herpSearch("Oxybelis koehleri", getRef = T)
herpSearch("Oxybelis rutherfordi", getRef = T)


write.csv(split_check, here::here("outputs", "matched.csv"), row.names = FALSE)

#####################################################################################


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


# exploratory analyses ----------------------------------------------------
head(allReptiles)
median(as.integer(allReptiles$year))

sort(table(allReptiles$order), decreasing = TRUE)
