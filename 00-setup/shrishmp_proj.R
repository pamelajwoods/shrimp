setwd("/home/pamela/Documents/gadget-models/41-shrimp_VERYbest/01-firsttry")

setwd("/home/pamela/Documents/gadget-models/41-shrimp_TuesdaysecondBEST/01-firsttry")
#gadget.forward()
#years = 100, effort = seq(0, 1, 0.05), rec.window = 2004)

#FIRST change dl to 0.1 in shimm and shmat files
tmp <- gadget.forward(years = 100, 
                      effort = seq(0, 1, 0.01),
                      fleets = data.frame(fleet = 'tms',ratio = 1),
                      params.file = 'WGTS/params.final')#, 
                      #rec.window = 2005)
#tmp<-gadget.forward(years = 100, effort = seq(0, 1, 0.05), rec.window = 2004:2016, ref.years = 2010:2016)




catch_by_year <- tmp$catch %>% 
  group_by(year,effort,trial) %>% 
  summarise(catch = sum(biomass_consumed)/1000) 

catch_by_year %>% 
  filter(year == '2116') %>% #View()
  ggplot(aes(effort,catch)) + 
  geom_point()

#change dl to 0.1 in shimm and shmat files
tmp <- gadget.forward(years = 100, 
                      effort = seq(0, 2, 0.1),
                      fleets = data.frame(fleet = 'tms',ratio = 1),
                      params.file = 'WGTS/params.final', 
                      rec.window = 2001)
#gadget.forward(years = 100, effort = seq(0, 1, 0.05), rec.window = 2004:2016, ref.years = 2010:2016)

catch_by_year <- tmp$catch %>% 
  group_by(year,effort,trial) %>% 
  summarise(catch = sum(biomass_consumed)/1000) 

catch_by_year %>% 
  filter(year == '2116') %>% #View()
  ggplot(aes(effort,catch)) + 
  geom_point()

View(catch_by_year)


