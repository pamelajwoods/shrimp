## Collect catches by fleet:
sht.landings <- mfdb_sample_totalweight(mdb, NULL, c(list(
  gear=c('SHT'),
  sampling_type = c('LND'), #,weights for 'INS','XINS','XS' are likely scaled by towcount and area because they are length data, in ldist
  species = defaults$species),
  defaults))

#this should perhaps be made more realistic

ins.landings <- 
  structure(data.frame(year=rep(defaults$year, each = 2),step=rep(c(1,2),length.out = length(defaults$year)*2),area=1,number=1),
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
                name = 'ins',
                suitability = paste0('\n',
                                     paste(c('shimm','shmat'),
                                           'function','exponentiall50',
                                           '#sh.ins.alpha','#sh.ins.l50',
                                           collapse='\n')),
                data = ins.landings) %>%
  
  gadget_update('totalfleet', #for now has same suitability
                name = 'sht',
                suitability = 
                  paste0('\n',
                         paste(c('shimm','shmat'),
                               'function','exponentiall50',
                               '#sh.ins.alpha','#sh.ins.l50',
                               collapse='\n')),
                data = sht.landings[[1]]) %>% 
write.gadget.file(gd$dir)