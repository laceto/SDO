# test for the tables 2.2.12, taking as matching table the 2.2.11.
# for this task, it can be re-used the function sdo_check() previously written.

# getting the matching table:

sheets_names <- list("Tav_2.2.11", "Tav_2.2.11", "Tav_2.2.11", "Tav_2.2.11")
Years <- list("2016", "2017", "2018", "2019")

matching_tables_2.2.11 <- 
  purrr::pmap(list(sheets_names, files_names, Years), read_sdo_check) %>%
  dplyr::bind_rows() %>%
  dplyr::mutate(ATTIVITÀ = "Acuti - Regime diurno") 

# it's needed to add the column with the MDC class to table 2.2.12. (not present in 2.2.12)
# rename the column DIMISSIONI to Dimissioni in order to use the function test_mdc().

cleaned_2.12 <- dplyr::left_join(x = merged_data_2.12, y = merged_data, 
                                 by = c("DRG", "CODICE", "TIPO", "ANNO"), all.y = FALSE) %>% 
  dplyr::select(TIPO:ATTIVITÀ.x, CLASSE_MDC, TAVOLA.x) %>%
  dplyr::rename(DIMISSIONI = "Dimissioni",
                ATTIVITÀ = "ATTIVITÀ.x",
                TAVOLA = "TAVOLA.x")

# there are some NA values in MDC_class, after having identify them, add the corresponding class.

SDO_diurno <- cleaned_2.12 %>% 
  dplyr::mutate(CLASSE_MDC = if_else(is.na(CLASSE_MDC) & DIMISSIONI == 0 , 
                              "MDC 15 - Malattie e disturbi del periodo neonatale",
                              CLASSE_MDC)) %>%
  dplyr::mutate(CLASSE_MDC = if_else(is.na(CLASSE_MDC),"12 - Malattie e disturbi dell'apparato riproduttivo maschile",
                             CLASSE_MDC)) 


purrr::map(Years, test_mdc, data = SDO_diurno, matching_table = matching_tables_2.2.11)
# for all of the 4 years, the result is TRUE.

SDO_diurno[c(1409,1947),]$CLASSE_MDC <- "MDC 12 - Malattie e disturbi dell'apparato riproduttivo maschile"
