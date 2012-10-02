# Clean file:
# Remove empty columns
col2stay <- adply(rawdata, .(2), function(x) sum(is.na(x)) != dim(rawdata)[1])
rawdata <- rawdata[, col2stay$V1]

# Prepare to convert column names to dates
rawdata[1, ] <- str_replace(as.character(rawdata[1,]), ' год', '')
for (i in 2:dim(rawdata)[2]) {
				if(is.na(rawdata[1, i])) rawdata[1, i] <- rawdata[1, i - 1]
}
rawdata[2,] <- str_c(as.character(rawdata[2,]), '.', as.character(rawdata[1,]))
rawdata[2,1] <- 'district'
colnames(rawdata) <- as.character(rawdata[2, ])
rawdata <- rawdata[-(1:2), ]

# Clean regions names
#  Remove digits (left from footer notes)
rawdata$district <- str_replace(rawdata$district, '(.*)\\d', '\\1')

#  Remove duplicated blanks
rawdata$district <- str_replace_all(rawdata$district, '  +', ' ')
rawdata$district <- str_trim(rawdata$district)

#  Convert "г." to "город"
rawdata$district <- str_replace(rawdata$district, '^г.', 'город ')

# "авт. округ" to "автономный округ"
rawdata$district <- str_replace(rawdata$district, 'авт. ?округ', 'автономный округ')
rawdata$district <- str_replace(rawdata$district, 'авт. ?область', 'автономная область')
rawdata$district <- str_replace(rawdata$district, 'в том числе:? ', '')

# Set administrative level for every region (Okrug / Oblast / Avto.okrug)
rawdata$level <- NA
rawdata$level[str_detect(rawdata$district, 'Федерация')] <- "федерация"
rawdata$level[str_detect(rawdata$district, 'федеральный округ')] <- "округ"
rawdata$level[is.na(rawdata$level)] <- "субъект"

# Convert strings to numeric
# rawdata[1:dim(rawdata)[1], 2:dim(rawdata)[2]] <- as.numeric(rawdata[1:dim(rawdata)[1], 2:dim(rawdata)[2]])
rawdata[1, 2:dim(rawdata)[2]] <- as.numeric(rawdata[1, 2:dim(rawdata)[2]])

# Convert to dates
locale <- Sys.getlocale()
Sys.setlocale('LC_TIME', 'ru_RU.UTF-8')
Sys.setlocale('LC_TIME', locale)
