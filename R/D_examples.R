library(letsHerp)
library(ggplot2)
# SquamBase nomenclature check --------------------------------------------
allReptiles$year <- as.integer(allReptiles$year)
summary(allReptiles$year)

table(allReptiles$suborder, allReptiles$order)

years <- as.data.frame(table(allReptiles$year, allReptiles$suborder))
colnames(years) <- c("year", "suborder", "count")
years$year <- as.integer(as.character(years$year))  # ensure year is numeric

# Plot with ggplot2
ggplot(years, aes(x = year, y = count, color = suborder)) +
  geom_point(alpha = 0.7, size = 2) +
  geom_smooth(method = "loess", se = FALSE, span = 0.3) +
  scale_x_continuous(breaks = seq(1760, 2030, by = 10)) +
  labs(
    x = "Year",
    y = "Number of Species Described",
    color = "Suborder",
    title = "Reptile Species Descriptions per Year by Suborder"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


uetz_link <- herpAdvancedSearch(location = "-Arrakis")
uetz <- herpSpecies(uetz_link, tcores = 9)

sum(squambase$species %in% uetz) # 11612 matches, 98.8% of SquamBase, 132 unmatched names 1.12%

review <- squambase$species[which(!squambase$species %in% uetz)] #132 unmatched names 

squam_new <- herpSync(review, solveAmbiguity = TRUE, cores = 9)

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


# iucn example ------------------------------------------------------------

