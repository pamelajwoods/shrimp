minage <- sh.imm[[1]]$minage
maxage <- sh.mat[[1]]$maxage
maxlength <- sh.mat[[1]]$maxlength 
minlength <- sh.imm[[1]]$minlength
dl <- sh.imm[[1]]$dl

## Query length data to create IGFS catchdistribution components
ldist.ins1 <-
  mfdb_sample_count(mdb, 
                    c('age', 'length'), 
                    c(list(
                      data_source = 'iceland-ldist',
                      sampling_type = c('INS', 'XS','XINS'),
                      #month = 9:11,
                      gear=c('SHT'),
                      age = mfdb_interval("all",c(minage,maxage),
                                       open_ended = c("upper","lower")),
                      length = mfdb_interval("len", 
                                             seq(minlength, maxlength, by = dl),
                                             open_ended = c("upper","lower"))),
                      defaults))

ldist.ins2 <-
  mfdb_sample_count(mdb, 
                    c('age', 'length'), 
                    c(list(
                      data_source = 'iceland-ldist',
                      sampling_type = c('INS','XS','XINS'), #XS and XINS contribute nothing 
                      #month = 9:11,
                      gear=c('TMS'),
                      age = mfdb_interval("all",c(minage,maxage),
                                          open_ended = c("upper","lower")),
                      length = mfdb_interval("len", 
                                             seq(minlength, maxlength, by = dl),
                                             open_ended = c("upper","lower"))),
                      defaults))


# for(i in seq_along(ldist.igfs)){
#   attributes(ldist.igfs[[i]])$age$all <- minage:maxage
#   attr(attributes(ldist.igfs[[i]])$length$len0,'min') <- minlength
# }


# ## Age IGFS
# aldist.igfs <-
#   mfdb_sample_count(mdb, 
#                     c('age', 'length'),
#                     c(list(sampling_type = 'IGFS',
#                            data_source = 'iceland-aldist',
#                            age = mfdb_step_interval('age',by=1,from=minage,to=maxage,
#                                                     open_ended = "upper"),
#                            length = mfdb_interval("len", 
#                                                   seq(minlength, maxlength, by = dl),
#                                                   open_ended = c("upper","lower"))),
#                       defaults))
# for(i in seq_along(aldist.igfs)){
#   attr(attributes(aldist.igfs[[i]])$length$len0,'min') <- minlength
# }

matp.ins1 <- 
  mfdb_sample_count(mdb, c('sex','age','length'),
                    append(defaults,
                           list(sampling_type='INS',
                                gear = 'SHT',
                                #age=mfdb_group(mat_ages=minage:maxage),
                                length = mfdb_interval('len',
                                                       seq(minlength, maxlength, by = dl),
                                                       open_ended = c('lower','upper')),              
                                sex = mfdb_group(shimm = 'M', shmat = 'F'))))
names(matp.ins1[[1]])[4]<-"maturity_stage"



# ldist.tms <- 
#   mfdb_sample_count(mdb,
#                     c('age', 'length'), 
#                     c(list(
#                       sampling_type = c('SEA'),
#                       data_source = 'iceland-ldist',
#                       #year = 1988:2016,
#                       #gear=c('TMS'),
#                       age = mfdb_interval("all",c(minage,maxage),
#                                           open_ended = c("upper","lower")),
#                       length = mfdb_interval("len", 
#                                              seq(minlength, maxlength, by = dl),
#                                              open_ended = c("upper","lower"))),
#                       defaults))
#NO ENTRIES!
