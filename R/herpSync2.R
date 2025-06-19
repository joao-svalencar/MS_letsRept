#' Synchronize species names using synonym reference table
#'
#' @description
#' Loops over x 
#'
#' Supports interactive disambiguation in cases where multiple valid names are found for a given synonym. Optionally, unmatched names can be retained or returned as blank.
#'
#' @usage
#' herpSync2(x, verbose = FALSE)
#'
#' @param x A character vector of taxon names to be processed (e.g., species list, phylogenetic tip labels, or trait table entries).
#' @param verbose Logical. If \code{TRUE}, prints species information in the console. Default is \code{FALSE}.
#'
#' @return A data frame with the following columns:
#' \itemize{
#'   \item \code{query}: original input names from the query.
#'   \item \code{RDB}: best-matching valid names according to the RDB.
#'   \item \code{status}: description of the outcome (e.g., \code{up_to_date}, \code{"updated"}, \code{"ambiguous"},  \code{"not found"}).
#' }
#' @note
#' 
#' @references
#' Liedtke, H. C. (2018). AmphiNom: an amphibian systematics tool. *Systematics and Biodiversity*, 17(1), 1–6. https://doi.org/10.1080/14772000.2018.1518935
#'
#' @examples
#' query <- c("Vieira-Alencar authoristicus", "Boa atlantica", "Boa diviniloqua", "Boa imperator")
#' \donttest{
#' herpSync2(x=query)
#' }
#' 
#'
#' @export
#'
herpSync2 <- function(x, verbose = FALSE)
{
  search <- list()
  for(i in seq_along(x))
  {
    search[[i]] <- herpSearch(x[i], verbose = verbose)
    names(search)[i] <- x[i]
  }
  
  query <- c()
  RDB <- c()
  status <- c()
  
  for(i in seq_along(search))
  {
    query[i] <- names(search)[i]
    
    if(is.list(search[[i]]))
    {
      RDB[i] <- search[[i]]$species
      if(query[i]==RDB[i])
      {
        status[i] <- "up_to_date"  
      }else{
        status[i] <- "updated"
      }
    }
    if(is.character(search[[i]]))
    {
      RDB[i] <- "check Link"
      status[i] <- "ambiguous"
    }
  }
  df <- data.frame(query, RDB, status)
  return(df)
}
