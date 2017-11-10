
library(mfdb)
library(tidyverse)
devtools::install_github("fishvice/mar",  dependencies = FALSE)
library(mar)
library(purrr)
library(purrrlyr)
library(tidyr)
library(stringr)
library(ROracle)
library(dbplyr)

## oracle connection 
mar <- dbConnect(dbDriver('Oracle'))

## Create connection to MFDB database, as the Icelandic case study
mdb <- mfdb('Iceland')#, destroy_schema = TRUE)#,db_params = list(host='hafgeimur.hafro.is'))

source("shrimp_support_tables.R")

#these are the station fixes - they needed to be done after stodvar and togstodvar were joined
stations_joined <-
  lesa_stodvar(mar) %>% 
  left_join(tbl(mar,'vessel_map')) %>% 
  #left_join(tbl(mar,'catch_map')) %>% 
  mutate(saga_nr = nvl(saga_nr,0),
         ar = to_number(to_char(dags,'yyyy')),
         man = to_number(to_char(dags,'mm'))) %>% 
  dplyr::left_join(tbl(mar,'corrected_skiki')) %>%
  dplyr::left_join(tbl(mar, 'corrected_breidd')) %>%
  dplyr::left_join(tbl(mar, 'corrected_tognumer')) %>%
  dplyr::left_join(tbl(mar, 'corrected_togtimi')) %>%
  dplyr::left_join(tbl(mar, 'corrected_toglengd')) %>%
  dplyr::left_join(tbl(mar, 'corrected_fjardarreitur'))


rewrite<-0  

if(rewrite==1){
  dbRemoveTable(mar,'fiskar_umhverfi_fx')
  dbRemoveTable(mar,'fiskar_stodvar_fx')
  dbRemoveTable(mar,'fiskar_togstodvar_fx')
  dbRemoveTable(mar,'fiskar_numer_fx')
  
#now write tables for Rafn  

  fiskar_umhverfi_fx<-
    tbl(mar, 'corrected_botnhiti') %>%
    dplyr::full_join(tbl(mar, 'corrected_yfirbordshiti')) %>%
    compute(name='fiskar_umhverfi_fx',temporary=FALSE)
  
  fiskar_stodvar_fx <- 
    stations_joined %>% 
    select(synis_id, skiki.fx, kastad_n_breidd.fx, fjardarreitur.fx) %>% 
    filter(!(is.na(skiki.fx)==1 & is.na(kastad_n_breidd.fx)==1 & is.na(fjardarreitur.fx)==1)) %>% 
    distinct() %>% 
    compute(name='fiskar_stodvar_fx',temporary=FALSE)

  fiskar_togstodvar_fx <- 
    stations_joined %>% 
    select(synis_id, tognumer.fx, togtimi.fx, toglengd.fx) %>%  
    filter(!(is.na(tognumer.fx)==1 & is.na(togtimi.fx)==1 & is.na(toglengd.fx)==1)) %>%
    distinct() %>% 
    compute(name='fiskar_togstodvar_fx',temporary=FALSE)
    
  fiskar_numer_fx <- 
    tbl(mar,'corrected_afli') %>% 
    dplyr::full_join(tbl(mar,'corrected_vigt_synis')) %>% 
    distinct() %>% 
    compute(name='fiskar_numer_fx',temporary=FALSE)
}


#test that changes are instituted 

  tbl(mar, 'corrected_botnhiti') %>%
  dplyr::full_join(tbl(mar, 'corrected_yfirbordshiti'))%>% 
  arrange(synis_id) %>% 
  as.tibble() -> test_umh1
View(test_umh1)

test_umh2<-
  tbl_mar(mar, "fiskar.umhverfi") %>% 
  filter(synis_id %in% test_umh1$synis_id) %>% 
  select(synis_id, botnhiti, yfirbordshiti) %>% 
  arrange(synis_id) %>% 
  as.tibble()
View(test_umh2)
    