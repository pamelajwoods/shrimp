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
      suitability
      1/(1+exp(-0.001*20000*(seq(1.5,2,0.1)-1.9)))
        
    suggestions<-list(rec_length = (first3lengths[1]),
                      rec_age = first3ages[1],
                      Linf
                      )
    
    
    print("Suggested starting values:")
    print(suggestions)
    print("Also remember to set the recruitment step for 1 less than the appearance of recruitment in length distributions.")
    return(suggestions)
}

plot_init_growth<-function(suggestions){
  
}