## Collect catches by fleet:
tms.landings <- mfdb_sample_totalweight(mdb, NULL, c(list(
  gear=c('SHT'), #this gear designation is wrong in database
  sampling_type = c('LND'), #,weights for 'INS','XINS','XS' are likely scaled by towcount and area because they are length data, in ldist
  species = defaults$species),
  defaults))

#this should perhaps be made more realistic

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
                data = tms.landings[[1]]) %>% 
write.gadget.file(gd$dir)