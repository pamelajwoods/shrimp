minage <- sh.imm[[1]]$minage
maxage <- sh.mat[[1]]$maxage
maxlength <- sh.mat[[1]]$maxlength 
minlength <- sh.imm[[1]]$minlength
dl <- sh.imm[[1]]$dl

## Query length data to create IGFS catchdistribution components
ldist.ins <-
  mfdb_sample_count(mdb, 
                    c('age', 'length'), 
                    c(list(
                      data_source = 'iceland-ldist',
                      sampling_type = c('INS'),
                      month = 1:12,
                      gear=c('TMS', 'SHT'),
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

matp.ins <- 
  mfdb_sample_count(mdb, c('sex','age','length'),
                    append(defaults,
                           list(sampling_type='INS',
                                #age=mfdb_group(mat_ages=minage:maxage),
                                length = mfdb_interval('len',
                                                       seq(minlength, maxlength, by = dl),
                                                       open_ended = c('lower','upper')),              
                                sex = mfdb_group(shimm = 'M', shmat = 'F'))))
names(matp.ins[[1]])[4]<-"maturity_stage"



ldist.sht <- 
  mfdb_sample_count(mdb,
                    c('age', 'length'), 
                    c(list(
                      sampling_type = c('SEA','XS','XINS'),
                      data_source = 'iceland-ldist',
                      year = 1988:2016,
                      gear=c('SHT'),
                      age = mfdb_interval("all",c(minage,maxage),
                                          open_ended = c("upper","lower")),
                      length = mfdb_interval("len", 
                                             seq(minlength, maxlength, by = dl),
                                             open_ended = c("upper","lower"))),
                      defaults))

