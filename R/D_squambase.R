# SquamBase nomenclature update -------------------------------------------

uetz_link <- reptAdvancedSearch(location = "-Arrakis")
uetz <- reptSpecies(uetz_link, tcores = 9)

sum(squambase$species %in% uetz) # 11612 matches, 98.8% of SquamBase, 132 unmatched names 1.12%

review <- squambase$species[which(!squambase$species %in% uetz)] #132 unmatched names 

squam_new <- reptSync(review, solveAmbiguity = TRUE, cores = 9)

table(squam_new$status)
#ambiguous: 3; duplicated: 24; unknown: 10; updated: 95

write.csv(squam_new, here::here("outputs", "squambase_sync.csv"), row.names = FALSE)

herpTidySyn(squam_new, filter = c("ambiguous")) # three species

herpSpecies(herpSearch("Asaccus nasrullahi"), taxonomicInfo = T)
herpSearch("Asaccus griseonotus", getRef = TRUE)
herpSearch("Asaccus ingae", getRef = TRUE) # revalidated in 2024 possibly including A. nasrullanhi

herpSpecies(herpSearch("Liolaemus islugensis"), taxonomicInfo = T) 
herpSearch("Liolaemus tajzara")

herpSpecies(herpSearch("Subdoluseps pruthi"), taxonomicInfo = T) # ref from 2024 changes genus


herpTidySyn(squam_new, filter = c("duplicated")) # eight species likely to be synonymized
herpSearch("Nactus multicarinatus", getRef = T)


herpTidySyn(squam_new, filter = c("unknown")) # 

herpSearch("Amphisbaena spurrelli") # corrected
herpSearch("Lepidodactylus planicaudus") # corrected
herpSearch("Phelsuma v-nigra") # corrected
herpSearch("Pholidoscelis major") # "Pholidoscelis turukaeraensis" is a fossil species, see comments
herpSearch("Leiocephalus carinatus") # Leiocephalus anonymous is an extinct species, see comments
herpSearch("Leiocephalus carinatus") # Leiocephalus apertosulcus is an extinct species, see comments
herpSearch("Leiocephalus carinatus") # Leiocephalus roquetus is an extinct species, see comments
herpSearch("Leiolopisma telfairii") #Leiolopisma mauritiana is an extinct species (described from subfossil remains), see comments
herpSearch("Gloydius brevicaudus") # corrected
herpSearch("Madatyphlops arenarius") # "Madatyphlops cariei" is a fossil species, see comments

# check for species taxonomic split ---------------------------------------
split <- squambase$species[which(squambase$species %in% uetz)]

split_check <- reptSplitCheck(split, pubDate = 2024, cores = 9)

table(split_check$status)
#check_split     unknown  up_to_date 
#   93            34       11485

reptTidySyn(split_check, filter = "check_split")
reptTidySyn(split_check, filter = "unknown")

split_unk <- split_check[split_check$status=="unknown",]

split_unk_check <- reptSplitCheck(split_unk$query, pubDate = 2024, cores = 9)

reptSearch("Coryphophylax brevicauda")

reptSpecies(reptAdvancedSearch(synonym = "Natrix natrix"), taxonomicInfo = T)

a <- reptSearch("Natrix natrix")
a$url

Nn <- data.frame(species = a$species, url = a$url)
herpSynonyms(Nn)

write.csv(squam_new, here::here("outputs", "squambase_split.csv"), row.names = FALSE)


