#' Synchronize species names using The Reptile Databas
#'
#' @description
#' Queries a list of species parsed to \code{herpSearch} and returns a dataframe with current valid names for querried species
#'
#' @usage
#' herpSyncParallel(x, cores = max(1, parallel::detectCores() - 1), showProgress = TRUE)
#'
#' @param x A character vector of taxon names to be processed (e.g., species list, phylogenetic tip labels, or trait table entries).
#' @param solveAmbiguity Logical. If \code{TRUE}, samples the synonyms of species with ambiguous nomenclature
#' @param cores Integer. Number of CPU cores to use for parallel processing. Default is one less than the number of available cores.
#' @param showProgress Logical. If \code{TRUE}, prints sampling progress in the console. Default is \code{FALSE}.
#'
#' @return A data frame with the following columns:
#' \itemize{
#'   \item \code{query}: original input names from the query.
#'   \item \code{RDB}: best-matching valid names according to the RDB.
#'   \item \code{status}: description of the outcome (e.g., \code{up_to_date}, \code{"updated"}, \code{"ambiguous"},  \code{"not found"}).
#'   \item \code{url}: the url searched for each querried species. The urls of species with ambiguous nomenclature returns a list of species of which the querried species is considered a synonym
#' }
#' 
#' @note
#' 
#' @references
#' Liedtke, H. C. (2018). AmphiNom: an amphibian systematics tool. *Systematics and Biodiversity*, 17(1), 1–6. https://doi.org/10.1080/14772000.2018.1518935
#'
#' @examples
#' query <- c("Vieira-Alencar authoristicus", "Boa atlantica", "Boa diviniloqua", "Boa imperator")
#' \donttest{
#' herpSyncParallel(x=query)
#' }
#' 
#'
#' @export
#'
herpSyncParallel <- function(x, solveAmbiguity = TRUE, cores = max(1, parallel::detectCores() - 1), verbose = TRUE, showProgress = TRUE) {
  
  # Worker function: performs search + classifies result
  worker <- function(species_name) {
    result <- letsHerp::herpSearch(species_name)
    
    if (is.list(result)) {
      RDB <- result$species
      status <- if (species_name == RDB) "up_to_date" else "updated"
      url <- result$url
    } else if (is.character(result) && grepl("^https:", result)) {
      RDB <- "check Link"
      status <- "ambiguous"
      url <- result
    } else {
      RDB <- result
      status <- "unknown"
      url <- result
    }
    
    data.frame(query = species_name, RDB = RDB, status = status, url = url, stringsAsFactors = FALSE)
  }
  
  # Run in parallel using your safeParallel() function
  results <- safeParallel(x, FUN = worker, cores = cores, showProgress = showProgress)
  
  # Combine all individual data frames into one
  df <- do.call(rbind, results)
  
  if(solveAmbiguity){
  synSample <- df[df$RDB == "check Link", c("query", "url")]
  if(showProgress) message(sprintf("Sampling synonyms to approach ambiguity for %d species", nrow(synSample)))
  
    for(i in seq_along(synSample$query))
    {
      RDB_new <- c()
      status_new <- c()
      spp_syn <- herpSynonyms(herpSpecies(synSample$url[i], getLink = TRUE, showProgress = FALSE), showProgress = FALSE)
      synonyms <- spp_syn$species[synSample$query[i] == spp_syn$synonyms]
      
      if(length(synonyms)==1)
      {
        RDB_new <- synonyms
        status_new <- "updated"
      }else
        if(length(synonyms)>1)
        {
          RDB_new <- paste(synonyms, collapse = "; ")
          status_new <- "ambiguous"
        }else{
          RDB_new <- "not_found"
          status_new <- "not_found"
        }
      df$RDB[synSample$query[i]==df$query] <- RDB_new
      df$status[synSample$query[i]==df$query] <- status_new
      }
    return(df)
  }else{
  return(df)
  }
}
