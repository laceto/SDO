# population pyramids 2019 for UK and Italy 

file_path_ita <- list.files( path = "./data/italy", pattern = ".xlsx",
                         full.names = TRUE)

pop2019_raw <- readxl::read_xlsx(path = file_path_ita,
                                 sheet = "DCIS_POPRES1_12032021164756773")


pop_ita2019 <- pop2019_raw %>%
  dplyr::select(6, 8, 10 , 12, 13) %>%
  dplyr::rename(stato_civile = "Stato civile",
                Anno = "Seleziona periodo") %>%
  dplyr::filter(stato_civile == "totale",
                Sesso == "maschi" | Sesso == "femmine") %>%
  mutate(Età = stringr::str_remove_all(string = Età, pattern = " anni| e più") ) %>%
  dplyr::slice(1:(n()-2)) 

pop_ita2019 <- pop_ita2019 %>%
  tibble::add_column(Categoria_età = cut(as.numeric(pop_ita2019$Età), 
                          breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                          include.lowest = TRUE)) 

pop_ita2019 <- pop_ita2019 %>%  
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                          pattern = "\\(|\\]")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                           pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor) %>%
  dplyr::mutate(Categoria_età = c(rep("0-4",10), rep("5-9",10), rep("10-14",10),
                    rep("15-19",10), rep("20-24",10), rep("25-29",10),
                    rep("30-34",10), rep("35-39",10), rep("40-44",10),
                    rep("45-49",10), rep("50-54",10), 
                    rep("55-59",10), rep("60-64",10), 
                    rep("65-69",10), rep("70-74",10),
                    rep("75-79",10), rep("80-84",10), rep("85+",32)))

pop_ita2019$Categoria_età <- factor(pop_ita2019$Categoria_età,
                             c("0-4", "5-9", "10-14", "15-19", 
                               "20-24","25-29","30-34", "35-39",
                               "40-44", "45-49", "50-54", "55-59",
                               "60-64","65-69", "70-74","75-79",
                               "80-84", "85+"))

# ggplot(data = pop_ita2019, 
#        mapping = aes(x = ifelse(test = Sesso == "maschi", yes = -Value, no = Value), 
#                      y = Categoria_età , fill = Sesso)) +
#   geom_col() +
#   scale_x_symmetric(labels = abs) +
#   labs( title = "Piramide popolazione",
#         subtitle = "Italia, 2019",
#        x = "Popolazione",
#        y = "Età"
#        )
# 

# UK population 2019


file_uk =  list.files( path = "./data/UK", pattern = ".xlsx",
                       full.names = TRUE)[2]

raw_uk_pop19 <- readxl::read_xlsx(path = file_uk,
                                sheet = "2019", skip = 1)

raw_uk2019 <- raw_uk_pop19 %>%
  dplyr::filter(variable == "UNITED KINGDOM") %>%
  dplyr::select(-c(2,3)) 

raw_uk2019male <- raw_uk2019 %>%
  dplyr::select(1:93) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-1, -n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "maschi",
                Età = seq(from = 0, to = 90)) 

raw_uk2019male <- raw_uk2019male %>%
  tibble::add_column(Categoria_età = cut(raw_uk2019male$Età, 
                          breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                          include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                          pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                           pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


raw_uk2019female <- raw_uk2019 %>%
  dplyr::select(94:185) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "femmine",
                Età = seq(from = 0, to = 90)) %>%
  tibble::add_column(Categoria_età = cut(raw_uk2019male$Età, 
                          breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                          include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                          pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                           pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


uk_pop2019 <- dplyr::bind_rows(raw_uk2019male, raw_uk2019female) %>%
  dplyr::arrange(Età) %>%
  dplyr::mutate(Categoria_età = c(rep("0-4",10), rep("5-9",10), rep("10-14",10),
                    rep("15-19",10), rep("20-24",10), rep("25-29",10),
                    rep("30-34",10), rep("35-39",10), rep("40-44",10),
                    rep("45-49",10), rep("50-54",10), 
                    rep("55-59",10), rep("60-64",10), 
                    rep("65-69",10), rep("70-74",10),
                    rep("75-79",10), rep("80-84",10), rep("85+",12)))

uk_pop2019$Categoria_età <- factor(uk_pop2019$Categoria_età,
                             c("0-4", "5-9", "10-14", "15-19", 
                               "20-24","25-29","30-34", "35-39",
                               "40-44", "45-49", "50-54", "55-59",
                               "60-64","65-69", "70-74","75-79",
                               "80-84", "85+"))

# ggplot(data = uk_pop2019, 
#        mapping = aes(x = ifelse(test = Sesso == "maschi", yes = -popolazione,
#                                 no = popolazione), 
#                      y = Categoria_età , fill = Sesso)) +
#   geom_col() +
#   scale_x_symmetric(labels = abs) +
#   labs( title = "Piramide popolazione",
#         subtitle = "Regno Unito, 2019",
#         x = "Popolazione",
#         y = "Età"
#   )


# UK pop 2012

raw_uk_pop12 <- readxl::read_xlsx(path = file_uk,
                                  sheet = "2012")

raw_uk2012 <- raw_uk_pop12 %>%
  dplyr::filter(variable == "UNITED KINGDOM") %>%
  dplyr::select(-c(2,3)) 

raw_uk2012male <- raw_uk2012 %>%
  dplyr::select(1:93) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-1, -n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "maschi",
                Età = seq(from = 0, to = 90)) 

raw_uk2012male <- raw_uk2012male %>%
  tibble::add_column(Categoria_età = cut(raw_uk2012male$Età, 
                                 breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                                 include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                                 pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                                  pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


raw_uk2012female <- raw_uk2012 %>%
  dplyr::select(94:185) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "femmine",
                Età = seq(from = 0, to = 90)) %>%
  tibble::add_column(Categoria_età = cut(raw_uk2012male$Età, 
                                 breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                                 include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                                 pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                                  pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


uk_pop2012 <- dplyr::bind_rows(raw_uk2012male, raw_uk2012female) %>%
  dplyr::arrange(Età) %>%
  dplyr::mutate(Categoria_età = c(rep("0-4",10), rep("5-9",10), rep("10-14",10),
                                  rep("15-19",10), rep("20-24",10), rep("25-29",10),
                                  rep("30-34",10), rep("35-39",10), rep("40-44",10),
                                  rep("45-49",10), rep("50-54",10), 
                                  rep("55-59",10), rep("60-64",10), 
                                  rep("65-69",10), rep("70-74",10),
                                  rep("75-79",10), rep("80-84",10), rep("85+",12)))

uk_pop2012$Categoria_età <- factor(uk_pop2012$Categoria_età,
                                   c("0-4", "5-9", "10-14", "15-19", 
                                     "20-24","25-29","30-34", "35-39",
                                     "40-44", "45-49", "50-54", "55-59",
                                     "60-64","65-69", "70-74","75-79",
                                     "80-84", "85+"))

#ENGLAND population 2019
raw_eng_pop19 <- readxl::read_xlsx(path = file_uk,
                                   sheet = "2019", skip = 1)

raw_eng2019 <- raw_eng_pop19 %>%
  dplyr::filter(variable == "ENGLAND") %>%
  dplyr::select(-c(2,3)) 

raw_eng2019male <- raw_eng2019 %>%
  dplyr::select(1:93) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-1, -n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "maschi",
                Età = seq(from = 0, to = 90))

raw_eng2019male <-raw_eng2019male %>%
  add_column(Categoria_età = cut(raw_eng2019male$Età, 
                                 breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                                 include.lowest = TRUE)) %>%
  mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                                 pattern = "\\(|\\]|\\[")) %>%
  mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                                  pattern = "\\,", replacement = "-")) %>%
  mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  mutate_at(vars(Categoria_età), factor)


raw_eng2019female <- raw_eng2019 %>%
  dplyr::select(94:185) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "femmine",
                Età = seq(from = 0, to = 90)) %>%
  tibble::add_column(Categoria_età = cut(raw_eng2019male$Età, 
                                 breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                                 include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                                 pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                                  pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


eng_pop2019 <- dplyr::bind_rows(raw_eng2019male, raw_eng2019female) %>%
  dplyr::arrange(Età) %>%
  dplyr::mutate(Categoria_età = c(rep("0-4",10), rep("5-9",10), rep("10-14",10),
                                  rep("15-19",10), rep("20-24",10), rep("25-29",10),
                                  rep("30-34",10), rep("35-39",10), rep("40-44",10),
                                  rep("45-49",10), rep("50-54",10), 
                                  rep("55-59",10), rep("60-64",10), 
                                  rep("65-69",10), rep("70-74",10),
                                  rep("75-79",10), rep("80-84",10), rep("85+",12)))

eng_pop2019$Categoria_età <- factor(eng_pop2019$Categoria_età,
                                    c("0-4", "5-9", "10-14", "15-19", 
                                      "20-24","25-29","30-34", "35-39",
                                      "40-44", "45-49", "50-54", "55-59",
                                      "60-64","65-69", "70-74","75-79",
                                      "80-84", "85+"))





#ENGLAND population 2012 (the one used for computing hospitalization rates)
raw_eng_pop12 <- readxl::read_xlsx(path = file_uk,
                                  sheet = "2012")

raw_eng2012 <- raw_eng_pop12 %>%
  dplyr::filter(variable == "ENGLAND") %>%
  dplyr::select(-c(2,3)) 

raw_eng2012male <- raw_eng2012 %>%
  dplyr::select(1:93) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-1, -n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "maschi",
                Età = seq(from = 0, to = 90)) 

raw_eng2012male <- raw_eng2012male %>%
  tibble::add_column(Categoria_età = cut(raw_eng2012male$Età, 
                                 breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                                 include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                                 pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                                  pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


raw_eng2012female <- raw_eng2012 %>%
  dplyr::select(94:185) %>%
  tidyr::gather(Età, popolazione) %>%
  dplyr::slice(-n()) %>%
  dplyr::mutate_at(vars(popolazione), as.numeric) %>%
  dplyr::mutate(Sesso = "femmine",
                Età = seq(from = 0, to = 90)) %>%
  tibble::add_column(Categoria_età = cut(raw_eng2012male$Età, 
                                 breaks = c(0,4,seq(9, 84, 5)), right = TRUE,
                                 include.lowest = TRUE)) %>%
  dplyr::mutate(Categoria_età = stringr::str_remove_all(string = Categoria_età,
                                                 pattern = "\\(|\\]|\\[")) %>%
  dplyr::mutate(Categoria_età = stringr::str_replace_all(string = Categoria_età,
                                                  pattern = "\\,", replacement = "-")) %>%
  dplyr::mutate(Categoria_età = replace_na(Categoria_età, "85+")) %>%
  dplyr::mutate_at(vars(Categoria_età), factor)


eng_pop2012 <- dplyr::bind_rows(raw_eng2012male, raw_eng2012female) %>%
  dplyr::arrange(Età) %>%
  dplyr::mutate(Categoria_età = c(rep("0 - 4",10), rep("5 - 9",10), rep("10 - 14",10),
                                  rep("15 - 19",10), rep("20 - 24",10), rep("25 - 29",10),
                                  rep("30 - 34",10), rep("35 - 39",10), rep("40 - 44",10),
                                  rep("45 - 49",10), rep("50 - 54",10), 
                                  rep("55 - 59",10), rep("60 - 64",10), 
                                  rep("65 - 69",10), rep("70 - 74",10),
                                  rep("75 - 79",10), rep("80 - 84",10), rep("85+",12)))

eng_pop2012$Categoria_età <- factor(eng_pop2012$Categoria_età,
                                   c("0 - 4", "5 - 9", "10 - 14", "15 - 19", 
                                     "20 - 24","25 - 29","30 - 34", "35 - 39",
                                     "40 - 44", "45 - 49", "50 - 54", "55 - 59",
                                     "60 - 64","65 - 69", "70 - 74","75 - 79",
                                     "80 - 84", "85+"))



# the surgical incidence is computed with the English population of the year
# 2012, so in order to obtain the total incidence for both male e female: 

pop2012_eng_m <- eng_pop2012 %>%
  dplyr::filter(Sesso == "maschi") %>%
  dplyr::pull(popolazione) %>%
  sum()


pop2012_eng_f <- eng_pop2012 %>%
  dplyr::filter(Sesso == "femmine") %>%
  dplyr::pull(popolazione) %>%
  sum()


England_sur_incidence <- eng_surgery_incidence %>%
  dplyr::mutate_at(vars(MALE,FEMALE), as.numeric) %>%
  dplyr::add_row(`AGE CATEGORY` = "Total",
                 MALE = sum(as.numeric(UK_surgery$MALE)) / pop2012_eng_m ,
                 FEMALE = sum(as.numeric(UK_surgery$FEMALE)) / pop2012_eng_f,
                 YEAR = "2019")

sum(as.numeric(UK_surgery$MALE)+as.numeric(UK_surgery$FEMALE)) / (pop2012_eng_m +pop2012_eng_f)


