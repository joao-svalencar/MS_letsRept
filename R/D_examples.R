library(letsHerp)
# SquamBase nomenclature check --------------------------------------------

uetz_link <- herpAdvancedSearch(location = "-Arrakis")
uetz <- herpSpecies(uetz_link, cores = 9)

sum(squambase$species %in% uetz) # 11612 matches, 98.8% of SquamBase, 132 outdated

review <- squambase$species[which(!squambase$species %in% uetz)] #132 unmatched names 

squam_new <- herpSync(review, solveAmbiguity = TRUE, cores = 9)

table(squam_new$status)
#ambiguous: 3; duplicated: 24; unknown: 10; updated: 95

write.csv(squam_new, here::here("outputs", "squambase_sync.csv"), row.names = FALSE)

herpTidySyn(squam_new, filter = c("ambiguous")) # 
herpTidySyn(squam_new, filter = c("duplicated")) # 
herpTidySyn(squam_new, filter = c("unknown")) # 

herpSearch("Amphisbaena spurrelli") # corrected
herpSearch("Phelsuma v-nigra") # corrected

# check for species taxonomic split ---------------------------------------
split <- squambase$species[which(squambase$species %in% uetz)]

split_check <- herpSplitCheck(split, pubDate = 2024, cores = 9)

table(split_check$status)
#check_split     unknown  up_to_date 
#   93            34       11485

herpTidySyn(split_check, filter = "check_split")
herpTidySyn(split_check, filter = "unknown")

split_unk <- split_check[split_check$status=="unknown",]

split_unk_check <- herpSplitCheck(split_unk$query, pubDate = 2024, cores = 9)

herpSearch("Coryphophylax brevicauda")

herpSpecies(herpAdvancedSearch(synonym = "Natrix natrix"), taxonomicInfo = T)

a <- herpSearch("Natrix natrix")
a$url

Nn <- data.frame(species = a$species, url = a$url)
herpSynonyms(Nn)

write.csv(squam_new, here::here("outputs", "squambase_split.csv"), row.names = FALSE)
