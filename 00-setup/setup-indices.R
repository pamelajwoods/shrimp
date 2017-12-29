#Why does weight need to be scaled by distance but not count?
#Is this data source right still?
# mfdb_dplyr_sample(mdb) %>% 
#   filter(species == 'SHR', 
#          sampling_type %in% sample_sources, 
#          data_source == 'iceland-ldist', 
#          #gear == 'SHT', 
#          areacell %in% defaults$area$'1',
#          year %in% c(1989:1995)) ->tmp
# tmp %>% 
#   filter(length <=1.1, year == 1991) %>% 
#   as.tibble() %>% 
#   summarise(total = sum(weight*count))
#   
#   tbl(mar,'ldist') %>% filter(species == 'SHR') %>% left_join(tbl(mar,'stations'), by='tow') %>% filter(year>1985,sampling_type=='INS', areacell %in% defaults$area$'1') %>%  group_by(year,lengd) %>% summarise(bio=sum(nvl(fjoldi,1)*mean_wt), bio_lw = sum(nvl(fjoldi,1)*0.000628641104521994*lengd^2.84713109335131)) %>% collect(n=Inf) %>% ggplot(aes(lengd,bio_lw)) + geom_line() + facet_wrap(~year,scale = 'free_y') + geom_line(aes(lengd,bio),lty=2)  
# 
#   ins1.SI1[[1]] %>% mutate(length = 0.9) %>%
#       full_join(ins1.SI2[[1]] %>% mutate(length = 1.2)) %>%
#       full_join(ins1.SI3[[1]] %>% mutate(length = 1.425)) %>%
#       full_join(ins1.SI4[[1]] %>% mutate(length = 1.625)) %>%
#       full_join(ins1.SI5[[1]] %>% mutate(length = 1.8)) %>%
#       full_join(ins1.SI6[[1]] %>% mutate(length = 2.15)) %>%
#       full_join(ins1.SI7[[1]] %>% mutate(length = 2.35)) %>%
#       filter(step==4) %>% 
#       group_by(year, length)-> joined_ind
#       
#       joined_ind %>% 
#       ggplot(aes(length,number)) + geom_line() + facet_wrap(~year) 
#   
#   tbl(mar,'ldist') %>% filter(species == 'SHR') %>% left_join(tbl(mar,'stations'), by='tow') %>% filter(year>1985,sampling_type=='INS', areacell %in% defaults$area$'1') %>%  group_by(year,lengd) %>% summarise(bio=sum(nvl(fjoldi,1)*mean_wt), bio_lw = sum(nvl(fjoldi,1)*0.000628641104521994*lengd^2.84713109335131)) %>% collect(n=Inf) %>% left_join(joined_ind, by = c('year', 'lengd' = 'length')) %>% ggplot(aes(lengd,bio_lw)) + geom_line() + facet_wrap(~year,scale = 'free_y') + geom_line(aes(lengd,bio),lty=2)+ geom_point(aes(lengd,number/10))  

  ## INS survey indices

ins1.SI <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', #why data-source ldist here but not in catch distributions
    sampling_type = sample_sources,#
    #gear = 'SHT',
    #month = 1:3,
    length = mfdb_interval("len", c(0.5, 2.5),open_ended = c('upper','lower'))),
    defaults))

 ins2.SI <- 
   mfdb_sample_totalweight(mdb, c('length'), c(list(
     data_source = 'iceland-ldist', #why data-source ldist here but not in catch distributions
     sampling_type = sample_sources,# #XS and XINS contribute nothing
     #gear = 'TMS',
     #month = 7:12,
     length = mfdb_interval("len", c(0.5, 2.5),open_ended = c('upper','lower'))),
     defaults)) 
 
 # test<-mfdb_dplyr_sample(mdb)%>%
 #   filter(species == 'SHR', sampling_type == 'INS', #gear == 'TMS', year == 2005, data_source == 'iceland-ldist') %>% 
 #   as.tibble()


#for comparison later
ins1.SI1 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(0.5, 1.1),open_ended = c('lower'))),
    defaults))



ins1.SI2 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist',
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(1.1, 1.3))),
    defaults))

ins1.SI3 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(1.3, 1.55))),
    defaults))

ins1.SI4 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(1.55, 1.7))),
    defaults))

ins1.SI5 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(1.7, 1.9))),
    defaults))

ins1.SI6 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(1.9, 2.2))),
    defaults))

ins1.SI7 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist',
    sampling_type = sample_sources,#
    #gear = 'SHT',
    length = mfdb_interval("len", c(2.2, 2.5),open_ended = c('upper'))),
    defaults))
#for comparison later
ins2.SI1 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(0.5, 1.1),open_ended = c('lower'))),
    defaults))

ins2.SI2 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist',
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(1.1, 1.3))),
    defaults))

ins2.SI3 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(1.3, 1.55))),
    defaults))

ins2.SI4 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(1.55, 1.7))),
    defaults))

ins2.SI5 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(1.7, 1.9))),
    defaults))

ins2.SI6 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(1.9, 2.2))),
    defaults))

ins2.SI7 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist',
    sampling_type = sample_sources,# #XS and XINS contribute nothing
    #gear = 'TMS',
    length = mfdb_interval("len", c(2.2, 2.5),open_ended = c('upper'))),
    defaults))

fixup_indices<-function(data, step_sub = 1){
  names(data)[5]<-"number"
  data %>% filter(!is.na(number), step == step_sub) 
}

  ins1.SI[[1]]<-fixup_indices(ins1.SI[[1]], step_sub = 4)
  ins2.SI[[1]]<-fixup_indices(ins2.SI[[1]])
  ins1.SI1[[1]]<-fixup_indices(ins1.SI1[[1]], step_sub = 4)
  ins1.SI2[[1]]<-fixup_indices(ins1.SI2[[1]], step_sub = 4)
  ins1.SI3[[1]]<-fixup_indices(ins1.SI3[[1]], step_sub = 4)
  ins1.SI4[[1]]<-fixup_indices(ins1.SI4[[1]], step_sub = 4)
  ins1.SI5[[1]]<-fixup_indices(ins1.SI5[[1]], step_sub = 4)
  ins1.SI6[[1]]<-fixup_indices(ins1.SI6[[1]], step_sub = 4)
  ins1.SI7[[1]]<-fixup_indices(ins1.SI7[[1]], step_sub = 4)
  ins2.SI1[[1]]<-fixup_indices(ins2.SI1[[1]])
  ins2.SI2[[1]]<-fixup_indices(ins2.SI2[[1]])
  ins2.SI3[[1]]<-fixup_indices(ins2.SI3[[1]])
  ins2.SI4[[1]]<-fixup_indices(ins2.SI4[[1]])
  ins2.SI5[[1]]<-fixup_indices(ins2.SI5[[1]])
  ins2.SI6[[1]]<-fixup_indices(ins2.SI6[[1]])
  ins2.SI7[[1]]<-fixup_indices(ins2.SI7[[1]])
  
