init_growth<-function(dl = 1, n_ages = 10, first3ages = 1:3, first3lengths = c(15, 25, 32), Linf_est = 70, ageclassesvisible = TRUE){
    
      recl_firstguess <-
      recl_bounds <-
      recl_sd_firstguess <-
      recl_sd_bounds <-
      Linf_firstguess <-
      Linf_bounds <-
      k_firstguess <-
      k_bounds <-
      bbin_firstguess <-
      bbin_bounds <-
      mat_l50_firstguess<-
      mat_l50_bounds<-
        #make sure these do not return Inf
        #maturity
        1/(1+exp(-20*(c(1, 1.5, 1.7, 1.9, 2, 2.3)-1.8)))
      #suitability
      1/(1+exp(-25*(seq(1.3,2,0.05)-1.8)))
      #vb growth
      (3.2 - 2.5)*(1-exp(-0.001*266*1))
        
    suggestions<-list(rec_length = (first3lengths[1]),
                      rec_age = first3ages[1],
                      Linf
                      )
    
    
    print("Suggested starting values:")
    print(suggestions)
    print("Also remember to set the recruitment step for 1 less than the appearance of recruitment in length distributions.")
    return(suggestions)
}

plot(c(0.25, 0.29, 0.37, 0.34, 0.32, 0.46, 0.29, 0.47, 0.33, 0.26)~c(2006:2015), type = 'l')

plot_init_growth<-function(suggestions){
  
}


