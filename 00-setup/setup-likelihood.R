

# ## weird inconsistencies in Gadget
# aldist.ins[[1]]$step <- 2
# ldist.ins[[1]]$step <- 2
# matp.ins[[1]]$step <- 2


gadgetlikelihood('likelihood',gd$dir,missingOkay = TRUE) %>% 
  ## Write a penalty component to the likelihood file
  gadget_update("penalty",
                name = "bounds",
                weight = "0.5",
                data = data.frame(
                  switch = c("default"),
                  power = c(2),
                  upperW=10000,
                  lowerW=10000,
                  stringsAsFactors = FALSE)) %>%
  gadget_update("understocking",
                name = "understocking",
                weight = "100") %>% #
  gadget_update("catchdistribution",
                name = "ldist.ins1",
                weight = 1,
                data = ldist.ins1[[1]],
                fleetnames = c("ins1"),
                stocknames =stock_names) %>% 
  gadget_update("catchdistribution",
                name = "ldist.ins2",
                weight = 1,
                data = ldist.ins2[[1]],
                fleetnames = c("ins2"),
                stocknames =stock_names) %>% 
  # gadget_update("catchdistribution",
  #               name = "ldist.tms",
  #               weight = 1,
  #               data = ldist.tms[[1]], 
  #               fleetnames = c("tms"),
  #               stocknames = stock_names) %>% 
  gadget_update("stockdistribution",
                name = "matp.ins1",
                weight = 1,
                data = matp.ins1[[1]], 
                fleetnames = c("ins1"),
                stocknames =stock_names) %>% 
  gadget_update("surveyindices",
                name = "si1",
                weight = 1,
                biomass = 1,
                data = ins1.SI[[1]] %>% filter(step == 4), #not sure why it only takes step = 1
                fittype = 'fixedslopeloglinearfit',
                slope = 1,
                stocknames = stock_names) %>%
  gadget_update("surveyindices",
                name = "si2",
                weight = 1,
                biomass = 1,
                data = ins2.SI[[1]],
                fittype = 'fixedslopeloglinearfit',
                slope = 1,
                stocknames = stock_names) %>%
  # gadget_update("surveyindices", ADD BIOMASS = 1
  #               name = "si1",
  #               weight = 1,
  #               data = ins.SI1[[1]],
  #               fittype = 'loglinearfit',
  #               stocknames = stock_names) %>%
  # gadget_update("surveyindices",
  #               name = "si2",
  #               weight = 1,
  #               data = ins.SI2[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope = 1,
  #               stocknames = stock_names) %>%
  # gadget_update("surveyindices",
  #               name = "si3",
  #               weight = 1,
  #               data = ins.SI3[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>%
  # gadget_update("surveyindices",
  #               name = "si4",
  #               weight = 1,
  #               data = ins.SI4[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>%
  # gadget_update("surveyindices",
  #               name = "si5",
  #               weight = 1,
  #               data = ins.SI5[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>%
  # gadget_update("surveyindices",
  #               name = "si6",
  #               weight = 1,
  #               data = ins.SI6[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>%
  # gadget_update("surveyindices",
  #               name = "si7",
  #               weight = 1,
  #               data = ins.SI7[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>%
   write.gadget.file(gd$dir)
