herpSplitCheck <- function(x, pubDate = NULL, verbose = TRUE){
  
  df_final <- data.frame(species=NULL, status=NULL)
  
  for (i in seq_along(x)){
    link <- herpAdvancedSearch(synonym = x[i], verbose = verbose)
    if (is.character(link) && grepl("^https:", link)){
      
      search <- rvest::read_html(link)
      title_node <- rvest::html_element(search, "h1")
      title_text <- rvest::html_text(title_node, trim = TRUE)
      
      if (grepl("^Search results", title_text)) {
        # This is a multi-species search results, page get nodes
        ul_element <- rvest::html_elements(search, "#content > ul:nth-child(6)")
        li_nodes <- xml2::xml_children(ul_element[[1]])
        
        query <- c()
        species <- c()
        years <- c()
        status <- c()
          for(j in seq_along(li_nodes))
          {
            target <- xml2::xml_child(li_nodes[[j]], 1)
            species[j] <- rvest::html_text(rvest::html_element(target, "em"), trim = TRUE)
            years[j] <- as.integer(stringr::str_extract(rvest::html_text(li_nodes[[j]]), "(?<!\\d)\\d{4}(?!\\d)"))
          }
        syn_df <- data.frame(species, years)
        
        if(any(syn_df$years >= pubDate, na.rm = TRUE))
        {
          query <- x[i]
          species <- paste(syn_df$species[which(syn_df$years >= pubDate)], collapse=";")
          status <- "check_split"
        }else
          if(x[i] %in% syn_df$species){
            query <- x[i]
            species <- x[i]
            status <- "up_to_date"
          }else{
            query <- x[i]
            species <- NA
            status <- "unknown"
          }
  
        df <- data.frame(query, species, status)
       } #is link?
    
      }else{
        search <- rvest::read_html(link$url)
        title_node <- rvest::html_element(search, "h1")
        if(x[i] == rvest::html_text(rvest::html_element(title_node, "em"), trim = TRUE)){
           query <- x[i]
           species <- rvest::html_text(rvest::html_element(title_node, "em"), trim = TRUE)
           status <- "up_to_date"
           df <- data.frame(query, species, status)
         }
      }
    if (exists("df")) {
      df_final <- rbind(df_final, df)
    }
    }# loop for
  return(df_final)
}

