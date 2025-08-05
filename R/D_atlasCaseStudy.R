# updating nomenclature with letsRept -------------------------------------

# install the package (GitHub), and load it
devtools::install_github("joao-svalencar/letsRept", ref="main", force=TRUE)
library(letsRept)
library(parallel)

#load Nogueira et al., (2019) Supp. Mat. Table S3 (georeferenced type localities)
atlas <- read.csv(here::here("data", "atlas.csv"))

# Creates a link for all snakes occurring in Brazil according to RDB
snakes_br_link <- reptAdvancedSearch(higher = "snakes", location ="Brazil") # 450 spp

# Samples each species higher taxa and respective URLs
snakes_br <- reptSpecies(snakes_br_link, taxonomicInfo = TRUE, cores = (parallel::detectCores()-1))
head(snakes_br)
 
# Exploring higher taxa information
reptStats(x = snakes_br, verbose = TRUE)
sort(table(snakes_br$family), decreasing = TRUE)

review <- reptCompare(atlas$species, snakes_br$species, filter = "review") #39 unmatched names 

snakes_names <- reptSync(review, solveAmbiguity = TRUE, cores = (parallel::detectCores()-1))
snakes_names

table(snakes_names$status)
# ambiguous duplicated up_to_date    updated 
#    3          2           1           33

#to check duplicated and ambiguous species:
reptTidySyn(snakes_names, filter = c("duplicated", "ambiguous")) #Table 3

reptSearch("Corallus cookii")
reptSearch("Corallus hortulana")

reptSearch("Adelphostigma occipitalis")
reptSearch("Adelphostigma quadriocellata")
reptSearch("Eutrachelophis papilio")

reptSearch("Tachymenis ocellata")
reptSearch("Tachymenis trigonatus")

reptSearch("Liotyphlops ternetzii")

write.csv(snakes_names, here::here("outputs", "Table S1.csv"), row.names = FALSE)

# taxize comparison -------------------------------------------------------
library(taxize)

taxize_sync <- gna_verifier(c("Corallus hortulanus",
                              "Liotyphlops beui",
                              "Liotyphlops sousai",
                              "Taeniophallus occipitalis",
                              "Tomodon ocellatus"),
                              all_matches = TRUE)


print(taxize_sync[,c("submittedName",
                     "currentName",
                     "dataSourceTitleShort",
                     "taxonomicStatus",
                     "sortScore")],
      n=length(taxize_sync$submittedName))

# check for species taxonomic split ---------------------------------------
matched <- reptCompare(atlas$species, snakes_br$species, filter = "matched") #372 unmatched names 

split_check <- reptSplitCheck(matched, pubDate = 2019, cores = (parallel::detectCores()-1))

table(split_check$status)
#check_split: 19; up_to_date: 353

#to check check_split species:
reptTidySyn(split_check, filter = c("check_split"))

#Atractus
reptSpecies(reptAdvancedSearch(synonym = "Atractus badius"), taxonomicInfo = T)
reptSearch("Atractus akerios")

reptSpecies(reptAdvancedSearch(synonym = "Atractus major"), taxonomicInfo = T)
reptSearch("Atractus nawa", getRef = T)

reptSpecies(reptAdvancedSearch(synonym = "Atractus snethlageae"), taxonomicInfo = T)
reptSearch("Atractus snethlageae", getRef = T)

#Chironius
reptSpecies(reptAdvancedSearch(synonym = "Chironius bicarinatus"), taxonomicInfo = T)
reptSearch("Chironius dracomaris", getRef = T)
reptSearch("Chironius gouveai", getRef = T)


reptSpecies(reptAdvancedSearch(synonym = "Chironius carinatus"), taxonomicInfo = T)
reptSearch("Chironius nigelnoriegai", getRef = T)

#Oxybelis aeneus
reptSpecies(herpAdvancedSearch(synonym = "Oxybelis aeneus"), taxonomicInfo = T)
reptSearch("Oxybelis inkaterra", getRef = T)
reptSearch("Oxybelis koehleri", getRef = T)
reptSearch("Oxybelis rutherfordi", getRef = T)

write.csv(split_check, here::here("outputs", "Table S2.csv"), row.names = FALSE)
