library(XLConnect)
library(stringr)
library(plyr)
library(reshape2)
library(lubridate)

# baseurl
burl <- "http://www.gks.ru/free_doc/doc_2012/monitor/"

# File details
subdir <- '01 промышленность'
xlfname <- '005-013 индекс промышленного производства'
xlfext <- 'xls'
xlffullname <- str_c(xlfname, xlfext, sep = '.')
sheetname <- "к пред. месяцу"
rfirst <- 3
rlast <- 96 # 0 if try to autodetect
cfirst <- 1
clast <- 0

# filename
fyear <- 2012
fmonth <- '07'
fname <- str_c("info-stat-", fmonth, "-", fyear)
fext <- 'rar'
ffullname <- str_c(fname, fext, sep = '.')

# Create temp-dir
tmpdir <- 'tmp'
dir.create(tmpdir)

# Download rar-archive
system(str_c('wget ', burl, ffullname, ' -P ', tmpdir))

# Extract rar-archive
system(str_c('unrar x ', tmpdir, '/',  ffullname, ' ', tmpdir))



rawdata <- readWorksheetFromFile(str_c(tmpdir, fname, subdir, xlffullname, sep = '/'),
																 sheetname, rfirst, cfirst, rlast , clast, header = F)


# Remove directory
system(str_c('rm -r ', tmpdir))
