library(Rgadget)
timestamp()
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        # grouping=list(sind1.1 = c('ins1.si1', 'ins1.si2', 'ins1.si3'), 
                        #               sind1.2 = c('ins1.si4', 'ins1.si5', 'ins1.si6', 'ins1.si7'), 
                        #               sind2.1 = c('ins2.si1', 'ins2.si2', 'ins2.si3'), 
                        #               sind2.2 = c('ins2.si4', 'ins2.si5', 'ins2.si6', 'ins2.si7')),
                        #cv.floor = 0.05,
                        params.file = 'params.init',
                        wgts='WGTS')

print('Running analytical retro')
timestamp()
gadget.retro(mainfile = 'WGTS/main.final',params.file = 'params.init')

