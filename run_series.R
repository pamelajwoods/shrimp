library(Rgadget)

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp/01-firsttry')
print("Base")

RunModel<-function(){
print(timestamp())
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(sind1.1 = c('ins1.si1', 'ins1.si2', 'ins1.si3'), 
                                      sind1.2 = c('ins1.si4', 'ins1.si5', 'ins1.si6', 'ins1.si7'), 
                                      sind2 = c('ins2.si1', 'ins2.si2', 'ins2.si3','ins2.si4', 'ins2.si5', 'ins2.si6', 'ins2.si7')), 
                        #cv.floor = 0.05,
                        params.file = 'params.init',
                        wgts='WGTS')

print('Running analytical retro')
print(timestamp())
gadget.retro(mainfile = 'WGTS/main.final',params.file = 'params.init')
}

RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I1.R1/01-firsttry')
print("Low Initial, Low Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I2.R1/01-firsttry')
print("Med Initial, Low Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I3.R1/01-firsttry')
print("High Initial, Low Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I1.R2/01-firsttry')
print("Low Initial, Med Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I2.R2/01-firsttry')
print("Med Initial, Med Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I3.R2/01-firsttry')
print("High Initial, Med Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I1.R3/01-firsttry')
print("Low Initial, High Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I2.R3/01-firsttry')
print("Med Initial, High Recruitment")
RunModel()

setwd('/net/hafkaldi/export/home/haf/pamela/gadget-models/41-shrimp_I3.R3/01-firsttry')
print("High Initial, High Recruitment")
RunModel()
