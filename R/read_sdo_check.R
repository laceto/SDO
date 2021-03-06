# function to get table "2.2.5" for each of the four years.
# Acuti - regime ordinario, dimissioni totali per MDC
read_sdo_check <- function(x, y, year) {
  
  raw_data <- readxl::read_xlsx(path = y,
                                sheet = x, skip = 3)
  names(raw_data)
  
  raw_data <- raw_data %>%
    dplyr::rename(CLASSE_MDC = "MDC")
  
  raw_data <- raw_data %>% 
    tidyr::drop_na() %>%
    dplyr::mutate(ANNO = year)%>% 
    dplyr::slice(-n()) 
  
    
    return(raw_data)
  
}

# get the table to match for all the 4 files.
files_names = list.files(path = "./data/", pattern = ".xlsx",
                         full.names = TRUE)

sheets_names <- list("Tav_2.2.5", "Tav_2.2.5", "Tav_2.2.5", "Tav_2.2.5")
Years <- list("2016", "2017", "2018", "2019")

matching_tables <- 
  purrr::pmap(list(sheets_names, files_names, Years), read_sdo_check) %>%
  dplyr::bind_rows() %>%
  dplyr::mutate(ATTIVITÀ = "Acuti - Regime ordinario") 


