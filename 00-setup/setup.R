#devtools::install_github('mareframe/mfdb',ref='5.x')
#devtools::install_github('fishvice/mar', force = TRUE)
#devtools::install_github('Hafro/rgadget')
#install.packages("tidyverse")
library(mar)
library(mfdb)
library(tidyverse)
library(Rgadget)
library(broom)
library(infuser)
bootstrap <- FALSE
## Create a gadget directory, define some defaults to use with our queries below
gd <- gadget_directory("01-firsttry")

mar <- dbConnect(dbDriver('Oracle'))
mdb<-mfdb('Iceland')#,db_params=list(host='hafgeimur.hafro.is'))

year_range <- 1986:2016 #CHANGE?
base_dir <- '41-shrimp'
mat_stock <- 'shmat'
imm_stock <- 'shimm'
stock_names <- c(imm_stock,mat_stock)
species_name <- 'sh'

reitmapping <- 
  tbl(mar, 'reitmapping') %>% #should this be changed to mfdb call?
  as.data.frame()
  # read.table(
  #       system.file("demo-data", "reitmapping.tsv", package="mfdb"),
  #       header=TRUE,
  #       as.is=TRUE)
#mfdb_timestep_biannually$'1'<-1:6#c(3,4,5,6,7,8)
#mfdb_timestep_biannually$'2'<-7:12#c(9,10,11,12,1,2)

mfdb_timestep_quarterly$'1'<-c(12,1,2)
mfdb_timestep_quarterly$'2'<-c(3,4,5)
mfdb_timestep_quarterly$'3'<-c(6,7,8)
mfdb_timestep_quarterly$'4'<-c(9,10,11)

defaults <- list(
    area = mfdb_group("1" = grep("52_",reitmapping$SUBDIVISION, value = T)), #mfdb_group("1" = unique(reitmapping$SUBDIVISION)),
    timestep = mfdb_timestep_quarterly,
    year = year_range,
    species = 'SHR')


gadgetfile('Modelfiles/time',
           file_type = 'time',
           components = list(list(firstyear = min(defaults$year),
                                  firststep=1,
                                  lastyear=max(defaults$year),
                                  laststep=length(defaults$timestep),
                                  notimesteps=c(length(defaults$timestep),rep(12/length(defaults$timestep), length.out = length(defaults$timestep)))))) %>% 
  write.gadget.file(gd$dir)

## Write out areafile and update mainfile with areafile location
gadget_areafile(
  size = mfdb_area_size(mdb, defaults)[[1]],
  temperature = mfdb_temperature(mdb, defaults)[[1]]) %>% 
  gadget_dir_write(gd,.)

source('../R/utils.R')
source('00-setup/setup-fleets.R')
source('00-setup/setup-model.R')
source('00-setup/setup-catchdistribution.R')
source('00-setup/setup-indices.R')
source('00-setup/setup-likelihood.R')

Sys.setenv(GADGET_WORKING_DIR=normalizePath(gd$dir))
callGadget(l=1,i='params.in',p='params.init')

if(FALSE){
  source('00-setup/setup-fixed_slope.R')
  ## setting up model variants
  source('00-setup/setup-est_slope.R')
  #source('06-sh/00-setup/setup-three_fleets.R')
  source('00-setup/setup-single_fleet.R')
}


if(bootstrap){
  source('00-setup/setup-bootstrap.R')
  file.copy(sprintf('%s/bootrun.R','41-shrimp/00-setup'),gd$dir)
}

file.copy(sprintf('%s/itterfitter.sh','00-setup'),gd$dir)
file.copy(sprintf('%s/run.R','00-setup'),gd$dir)
file.copy(sprintf('%s/optinfofile','00-setup'),gd$dir)
#file.copy(sprintf('%s/run-fixed_slope.R','41-shrimp/00-setup'),gd$dir)
