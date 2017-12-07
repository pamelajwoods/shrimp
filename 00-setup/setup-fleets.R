## Collect catches by fleet:
tms.landings <- mfdb_sample_totalweight(mdb, NULL, c(list(
  gear=c('SHT'), #this gear designation is wrong in database
  sampling_type = c('LND'), #,weights for 'INS','XINS','XS' are likely scaled by towcount and area because they are length data, in ldist
  species = defaults$species),
  defaults))

#tms.landings[[1]] %>% group_by(year) %>% summarise(weight = sum(total_weight)) -> tms.catch
#barplot(tms.catch$weight/1000, names = tms.catch$year)
#these data are wrong
temp_catch<-data_frame(year = c(1984, rep(1985:2016, each = 4), rep(2017,3)), 
           step = c(4, rep(1:4, length(1984:2016)-1),1:3), 
           area = rep(1, length(1984:2016)*4), 
           total_weight = rep(c(320, 300, 450, 690, 640, 740, 720, 600, 750, 850, 700, 705, 710, 540, 550, 555, 640, 750, 635, 440, 435, 10, 5, 150, 500, 305, 335, 220, 480, 200, 375, 260, 115)*1000/4, each = 4)) %>% 
          filter(year %in% year_range)

#this should perhaps be made more realistic
tms.landings<- structure(data.frame(year=temp_catch$year,step=temp_catch$step,area=1,total_weight = temp_catch$total_weight),
          area_group = mfdb_group(`1` = 1))


ins1.landings <- 
  structure(data.frame(year=rep(defaults$year, each = 4),step=rep(1:4,length.out = length(defaults$year)*4),area=1,number=1),
            area_group = mfdb_group(`1` = 1))

ins2.landings <- 
  structure(data.frame(year=rep(defaults$year, each = 4),step=rep(1:4,length.out = length(defaults$year)*4),area=1,number=1),
            area_group = mfdb_group(`1` = 1))

#This can't be used because weight column has been scaled by area and towcount to represent survey index
# ins.landings <- mfdb_sample_totalweight(mdb, NULL, c(list(
#   gear=c('TMS'),
#   sampling_type = c('INS','XINS','XS'),
#   data_source = 'iceland-ldist',
#   species = defaults$species),
#   defaults))


## write to file
gadgetfleet('Modelfiles/fleet',gd$dir,missingOkay = TRUE) %>% 
  gadget_update('totalfleet',
                name = 'ins1',
                suitability = paste0('\n',
                                     paste(c('shimm','shmat'),
                                           'function','exponentiall50',
                                           '#sh.ins1.alpha','#sh.ins1.l50',
                                           collapse='\n')),
                data = ins1.landings) %>%
gadget_update('totalfleet',
                name = 'ins2',
                suitability = paste0('\n',
                                     paste(c('shimm','shmat'),
                                           'function','exponentiall50',
                                           '#sh.tms.alpha','#sh.tms.l50',
                                           collapse='\n')),
                data = ins2.landings) %>%
  
  gadget_update('totalfleet', #for now has same suitability
                name = 'tms',
                suitability = 
                  paste0('\n',
                         paste(c('shimm','shmat'),
                               'function','exponentiall50',
                               '#sh.tms.alpha','#sh.tms.l50',
                               collapse='\n')),
                data = tms.landings) %>% 
write.gadget.file(gd$dir)