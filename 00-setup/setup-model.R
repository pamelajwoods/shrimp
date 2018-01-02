## Useful constansts

## weight length relationship
lw.constants <- 
  mfdb_dplyr_sample(mdb) %>% 
  filter(species == defaults$species,
         sampling_type == 'INS',
         data_source == 'iceland-aldist',
         !is.na(weight)) %>% 
  select(length,weight) %>% 
  collect(n=Inf) %>% 
  lm(log(weight/1e3)~log(length),.) %>% 
  broom::tidy() %>% 
  select(estimate)
## transport back to right dimension
lw.constants$estimate[1] <- exp(lw.constants$estimate[1])

## initial conditions sigma
# init.sigma <- 
#   mfdb_dplyr_sample(mdb) %>% 
#   dplyr::filter(species == defaults$species,age >0,!is.na(length))  %>% 
#   dplyr::select(age,length) %>% 
#   dplyr::collect(n=Inf) %>% 
#   dplyr::group_by(age) %>% 
#   dplyr::summarise(ml=mean(length,na.rm=TRUE),ms=sd(length,na.rm=TRUE))

#no age data so guessing from figures
init.sigma <- data.frame(ms = rep(0.25, 6)) #cm, estiamted from figures in Inga's reports


#get maturity from sex
mat.l50 <- 
  mfdb_dplyr_sample(mdb) %>% 
  filter(species == defaults$species,
         !is.na(sex)) %>% 
  select(length,sex) %>% 
  group_by(length,sex) %>% 
  dplyr::summarise(n=n()) %>% 
  group_by(length) %>% 
  dplyr::mutate(p=n/sum(n, na.rm = TRUE)) %>% 
  ungroup() %>% 
  filter(sex=='F',p>0.50, length>0.5) %>% 
  dplyr::summarise(l50=min(length, na.rm = TRUE)) %>% 
  collect(n=Inf)


## setup the immature stock first
sh.imm <- 
  gadgetstock('shimm',gd$dir,missingOkay = TRUE) %>%
  gadget_update('stock',
                minage = 1,
                maxage = 6,
                minlength = 0.7,
                maxlength = 2.5,
                dl = 0.1,
                livesonareas = 1) %>%
  gadget_update('doesgrow', ## note to self the order of these parameters make difference
                growthparameters=c(linf='#sh.Linf', 
                                   k='Modelfiles/timevariableK.imm',#to.gadget.formulae(quote(length.rate.scalar*shimm.k)),
                                   alpha = '#shimm.walpha',
                                   beta = '#shimm.wbeta'),
                beta = to.gadget.formulae(quote(10*sh.bbin)),
                maxlengthgroupgrowth = 1) %>% 
  gadget_update('initialconditions',
                normalparam = data_frame(age = .[[1]]$minage:.[[1]]$maxage,
                                         area = 1,
                                         age.factor = parse(text=sprintf('exp(-1*(shimm.M+sh.init.F)*%1$s)*shimm.init.%1$s*(1-1/(1+exp(-3*(%1$s-2.5))))',age[c(1:(length(age)-1),(length(age)-1))])) %>% 
                                           map(to.gadget.formulae) %>% 
                                           unlist(),   
                                         area.factor = '#shimm.init.scalar',
                                         mean = c(1, 1.4, 1.7, 1.8, 1.9, 2.1)*0.9, #von_b_formula(age*c(1, 0.9, rep(0.7, 4)),linf='sh.Linf',k='shimm.k',recl='sh.recl.1988'), # 
                                         stddev = init.sigma$ms[age],
                                         alpha = '#shimm.walpha',
                                         beta = '#shimm.wbeta')) %>% 
  ## does"something" updates should also allow for other names, e.g. doesrenew -> recruitment etc..
  gadget_update('refweight',
                data=data_frame(length=seq(.[[1]]$minlength,.[[1]]$maxlength,.[[1]]$dl),
                                mean=lw.constants$estimate[1]*length^lw.constants$estimate[2])) %>% 
  gadget_update('iseaten',1) %>% 
  gadget_update('doesmature', 
                maturityfunction = 'continuous',
                maturestocksandratios = 'shmat 1',
                coefficients = '( * #length.rate.scalar #sh.mat1) #sh.mat2 0 0') %>% 
  gadget_update('doesmove',
                transitionstocksandratios = 'shmat 1',
                transitionstep = 2) %>% 
  gadget_update('doesrenew',
                normalparam = data_frame(year = year_range,
                                         step = 3,
                                         area = 1,
                                         age = .[[1]]$minage,
                                         number = parse(text=sprintf('sh.rec.scalar*sh.rec.%s',year)) %>% 
                                           map(to.gadget.formulae) %>% 
                                           unlist(),
                                         mean = parse(text=sprintf('sh.recl.%s',year)) %>% 
                                           map(to.gadget.formulae) %>% 
                                           unlist(),
                                           #'#sh.recl',#von_b_formula(age,linf='sh.Linf',k='shimm.k',recl='sh.recl'), # 
                                         stddev = '#sh.recl.sd',
                                         alpha = '#shimm.walpha',
                                         beta = '#shimm.wbeta')) 




sh.mat <-
  gadgetstock('shmat',gd$dir,missingOkay = TRUE) %>%
  gadget_update('stock',
                minage = 1,
                maxage = 6,
                minlength = 0.7,
                maxlength = 2.5,
                dl = 0.1,
                livesonareas = 1) %>%
  gadget_update('doesgrow', ## note to self the order of these parameters make difference
                growthparameters=c(linf='#sh.Linf', 
                                   k=to.gadget.formulae(quote(length.rate.scalar*shmat.k)),
                                   alpha = '#shimm.walpha',
                                   beta = '#shimm.wbeta'),
                beta = to.gadget.formulae(quote(10*sh.bbin)),
                maxlengthgroupgrowth = 1) %>% 
  gadget_update('initialconditions',
                normalparam = data_frame(age = .[[1]]$minage:.[[1]]$maxage,
                                         area = 1,
                                         age.factor = parse(text=sprintf('exp(-1*(shmat.M+sh.init.F)*%1$s)*shimm.init.%1$s*1/(1+exp(-3*(%1$s-2.5)))',age[c(1:(length(age)-1),(length(age)-1))])) %>% 
                                           map(to.gadget.formulae) %>% 
                                           unlist(),
                                         area.factor = '#shimm.init.scalar',
                                         mean = c(1, 1.4, 1.7, 1.8, 1.9, 2.1),#von_b_formula(age*c(0.7, 0.9, rep(1, 4)),linf='sh.Linf',k='shmat.k',recl='sh.recl.1988'),#
                                         stddev = init.sigma$ms[age],
                                         alpha = '#shmat.walpha',
                                         beta = '#shmat.wbeta')) %>% 
  ## does"something" updates should also allow for other names, e.g. doesrenew -> recruitment etc..
  gadget_update('refweight',
                data=data_frame(length=seq(.[[1]]$minlength,.[[1]]$maxlength,.[[1]]$dl),
                                mean=lw.constants$estimate[1]*length^lw.constants$estimate[2])) %>% 
  gadget_update('iseaten',1) 


## write to file
sh.imm %>% 
  write.gadget.file(gd$dir)

sh.mat %>% 
  write.gadget.file(gd$dir)



Sys.setenv(GADGET_WORKING_DIR=normalizePath(gd$dir))
callGadget(s=1,log = 'init.log') #ignore.stderr = FALSE,

## update the input parameters with sane initial guesses
read.gadget.parameters(sprintf('%s/params.out',gd$dir)) %>% 
  init_guess('init.[0-9]',600,0.001,1500,1) %>%
  init_guess('rec.[0-9]',600,0.001,1500,1) %>%
  init_guess('recl',1,0.9,1.15,1) %>% 
  #init_guess('sh.rec.1988',600,0.001,1500,1) %>% 
  init_guess('sh.rec.1991',600,0.001,2000,1) %>% 
  #init_guess('sh.rec.1992',100,0.001,1500,1) %>% 
  #init_guess('sh.rec.1993',100,0.001,1500,1) %>% 
  #init_guess('sh.rec.1996',600,0.001,1500,1) %>% 
  #init_guess('sh.rec.1999',600,0.001,1500,1) %>% 
  init_guess('sh.recl.1992',0.95,0.9,1,1) %>% 
  #init_guess('sh.recl.1993',0.95,0.9,1.04,1) %>% 
  #init_guess('sh.recl.1994',0.95,0.9,1,1) %>% 
  #init_guess('sh.recl.2005',0.95,0.9,1.17,1) %>% 
  #init_guess('sh.recl.2006',0.95,0.9,1.18,1) %>% 
  #init_guess('sh.recl.2012',0.95,0.9,1.16,1) %>% 
  init_guess('recl.sd',0.05, 0.01, 0.07,1) %>% 
  init_guess('Linf',2.5, 2, 3.5,1) %>% 
  init_guess('k$',0.20, 0.1, 0.4,1) %>% 
  init_guess('k.[0-9]',0.20, 0.1, .35,1) %>% 
  init_guess('bbin',7, 1, 8, 1) %>% 
  init_guess('ins1.alpha', 25,  0.1, 50, 1) %>% 
  init_guess('ins1.l50', 1, 0.4, 2.4,1) %>% 
  #init_guess('tms.alpha', 25,  0.1, 50, 1) %>% 
  #init_guess('tms.l50',1 ,0.4,1.8,1) %>% 
  init_guess('walpha',lw.constants$estimate[1], 1e-10, 1,0) %>% 
  init_guess('wbeta',lw.constants$estimate[2], 2, 4,0) %>% 
  init_guess('M$',0.75,0.001,1,0) %>% 
  init_guess('rec.scalar',500,1,600,0) %>% 
  init_guess('shimm.init.scalar',700,1,1500,1) %>% 
  #init_guess('shmat.init.scalar',500,1,700,1) %>% 
  init_guess('mat2',mat.l50$l50,0.9*mat.l50$l50,1.1*mat.l50$l50,1) %>% 
  init_guess('mat1',10, 9, 21, 1) %>% 
  init_guess('init.F',0.5,0.1,1,1) %>% 
  init_guess('length.rate.scalar',1,0.1,1,0) %>% 
  # init_guess('p0',0,0,1,1) %>% 
  # init_guess('p2',1,0,1,1) %>% 
  # init_guess('p3',1,0.01,100,1) %>% 
  # init_guess('p4',1,0.01,100,1) %>% 
  # init_guess('mode',70,30,90,1) %>% 
  write.gadget.parameters(.,file=sprintf('%s/params.in',gd$dir))
