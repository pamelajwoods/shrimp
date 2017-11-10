

# ## weird inconsistencies in Gadget
# aldist.igfs[[1]]$step <- 2
# ldist.igfs[[1]]$step <- 2
# matp.igfs[[1]]$step <- 2


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
                name = "ldist.ins",
                weight = 1,
                data = ldist.ins[[1]],
                fleetnames = c("ins"),
                stocknames =stock_names) %>% 
  gadget_update("catchdistribution",
                name = "ldist.sht",
                weight = 1,
                data = ldist.sht[[1]], 
                fleetnames = c("sht"),
                stocknames = stock_names) %>% 
  gadget_update("stockdistribution",
                name = "matp.ins",
                weight = 1,
                data = matp.ins[[1]], 
                fleetnames = c("ins"),
                stocknames =stock_names) %>% 
  gadget_update("surveyindices",
                name = "si1",
                weight = 1,
                biomass = 1,
                data = ins.SI[[1]] %>% filter(step==1),
                fittype = 'fixedslopeloglinearfit',
                slope = 1,
                stocknames = stock_names) %>% 
  gadget_update("surveyindices",
                name = "si2",
                weight = 1,
                biomass = 1,
                data = ins.SI[[1]] %>% filter(step==2),
                fittype = 'fixedslopeloglinearfit',
                slope = 1,
                stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.20-50",
  #               weight = 1,
  #               data = igfs.SI1[[1]],
  #               fittype = 'loglinearfit',
  #               stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.50-60",
  #               weight = 1,
  #               data = igfs.SI2a[[1]],
  #               fittype = 'loglinearfit',
  #               stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.60-70",
  #               weight = 1,
  #               data = igfs.SI2b[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.70-80",
  #               weight = 1,
  #               data = igfs.SI3a[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.80-90",
  #               weight = 1,
  #               data = igfs.SI3b[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.90-100",
  #               weight = 1,
  #               data = igfs.SI3c[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>% 
  # gadget_update("surveyindices",
  #               name = "si.100-160",
  #               weight = 1,
  #               data = igfs.SI3d[[1]],
  #               fittype = 'fixedslopeloglinearfit',
  #               slope=1,
  #               stocknames = stock_names) %>% 
   write.gadget.file(gd$dir)
