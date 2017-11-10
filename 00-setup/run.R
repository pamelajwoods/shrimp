library(Rgadget)
timestamp()
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        #grouping=list(sind=c('ins.SI')),
                        #cv.floor = 0.05,
                        params.file = 'params.init',
                        wgts='WGTS')

print('Running analytical retro')
timestamp()
gadget.retro(mainfile = 'WGTS/main.final',params.file = 'params.init')

