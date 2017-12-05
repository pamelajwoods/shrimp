#Why does weight need to be scaled by distance but not count?
#Is this data source right still?

## INS survey indices

ins1.SI <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', #why data-source ldist here but not in catch distributions
    sampling_type = c('INS','XS','XINS'),
    gear = 'SHT',
    #month = 1:3,
    length = mfdb_interval("len", c(0.5, 2.5),open_ended = c('upper','lower'))),
    defaults))

 ins2.SI <- 
   mfdb_sample_totalweight(mdb, c('length'), c(list(
     data_source = 'iceland-ldist', #why data-source ldist here but not in catch distributions
     sampling_type = c('INS','XS','XINS'), #XS and XINS contribute nothing
     gear = 'TMS',
     #month = 7:12,
     length = mfdb_interval("len", c(0.5, 2.5),open_ended = c('upper','lower'))),
     defaults)) 
 
 # test<-mfdb_dplyr_sample(mdb)%>%
 #   filter(species == 'SHR', sampling_type == 'INS', gear == 'TMS', year == 2005, data_source == 'iceland-ldist') %>% 
 #   as.tibble()


#for comparison later
ins.SI1 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = 'INS',
    length = mfdb_interval("len", c(0.5, 1.1),open_ended = c('lower'))),
    defaults))

ins.SI2 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist',
    sampling_type = 'INS',
    length = mfdb_interval("len", c(1.1, 1.3))),
    defaults))

ins.SI3 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = 'INS',
    length = mfdb_interval("len", c(1.3, 1.5))),
    defaults))

ins.SI4 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = 'INS',
    length = mfdb_interval("len", c(1.5, 1.7))),
    defaults))

ins.SI5 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = 'INS',
    length = mfdb_interval("len", c(1.7, 1.9))),
    defaults))

ins.SI6 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist', 
    sampling_type = 'INS',
    length = mfdb_interval("len", c(1.9, 2.2))),
    defaults))

ins.SI7 <- 
  mfdb_sample_totalweight(mdb, c('length'), c(list(
    data_source = 'iceland-ldist',
    sampling_type = 'INS',
    length = mfdb_interval("len", c(2.2, 2.5),open_ended = c('upper'))),
    defaults))

fixup_indices<-function(data){
  names(data)[5]<-"number"
  data %>% filter(!is.na(number)) 
}

  ins1.SI[[1]]<-fixup_indices(ins1.SI[[1]])
  ins2.SI[[1]]<-fixup_indices(ins2.SI[[1]])
  ins.SI2[[1]]<-fixup_indices(ins.SI2[[1]])
  ins.SI3[[1]]<-fixup_indices(ins.SI3[[1]])
  ins.SI4[[1]]<-fixup_indices(ins.SI4[[1]])
  ins.SI5[[1]]<-fixup_indices(ins.SI5[[1]])
  ins.SI6[[1]]<-fixup_indices(ins.SI6[[1]])
  ins.SI7[[1]]<-fixup_indices(ins.SI7[[1]])
  
