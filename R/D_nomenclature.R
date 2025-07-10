# updating nomenclature with letsHerp -------------------------------------

# install the package (GitHub), load it, and view vignettes
devtools::install_github("joao-svalencar/letsHerp", ref="main", force=TRUE)
library(letsHerp)


#load Nogueira et al., (2019) Supp. Mat. Table S3 (georeferenced type localities)
atlas <- read.csv(here::here("data", "raw", "atlas.csv"))

# Creates a link for all snakes occurring in Brazil according to RDB
snakes_br_link <- herpAdvancedSearch(higher = "snakes", location = "Brazil") # 450 spp


# Samples each species higher taxa and respective URLs
snakes_br <- herpSpecies(snakes_br_link, taxonomicInfo = TRUE, getLink = TRUE, cores = 9)
snakes_br

# Exploring higher taxa information
sort(table(snakes_br$family), decreasing = TRUE)

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

write.csv(snakes_names, here::here("outputs", "Table S1.csv"), row.names = FALSE)

# check for species taxonomic split ---------------------------------------
matched <- atlas$species[which(atlas$species %in% snakes_br$species)]

split_check <- herpSplitCheck(matched, pubDate = 2019, cores = 9)

table(split_check$status)
#check_split: 19; up_to_date: 353

#to check check_split species:
herpTidySyn(split_check, filter = c("check_split"))

#Atractus
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


write.csv(split_check, here::here("outputs", "Table S2.csv"), row.names = FALSE)

#####################################################################################

#getting list of synonyms for all Brazilian snakes ----------------------
syn_br <- herpSynonyms(snakes_br) #2537 synonyms
sum(atlas$species %in% syn_br$synonyms) # all 411 species within the synonym list


# exploratory analyses ----------------------------------------------------
head(allReptiles)
median(as.integer(allReptiles$year))

sort(table(allReptiles$order), decreasing = TRUE)
