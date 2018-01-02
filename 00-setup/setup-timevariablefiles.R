# example
# timedat<-data_frame(year = rep(year_range, each=4), 
#                     step = rep(1:4, length(year_range)), 
#                     value = parse(text=sprintf('0.001*had.k.%s',yr_tmp)) %>%
#                       map(to.gadget.formulae)%>% 
#                       unlist())



gadgetfile('Modelfiles/timevariableK.imm',
           file_type = 'timevariable',
           components = list(list('annualgrowth',
                                  data= data_frame(year = rep(year_range, each=4), 
                                                   step = rep(1:4, length(year_range)), 
                                                   value = parse(text=sprintf('length.rate.scalar*shimm.k.%s', c(rep(1, length(year_range[1]:2003)*4), rep(2, (length(year_range) - length(year_range[1]:2003))*4)))) %>%
                                                     map(to.gadget.formulae)%>% 
                                                     unlist()))
           )) %>% 
  write.gadget.file(gd$dir)

