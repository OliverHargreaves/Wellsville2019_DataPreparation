# Separate the soil moisture sensor readings for into the two substations
# sensors 1-4 are one sub-station and 5-8 are the other one.


# Packages ####
library(tidyr)
library(readxl)
library(writexl)

# Data ####
data=read_xlsx('Midnight.xlsx') # original csv file with midnight data
data=data.frame('Date'=data$`DATE & TIME (UTC)`, 'Sensor'=data$Sensor...7, 'SM'=data$`VOL. WATER CONTENT (%)`) # data frame with the values we'll be using
data=spread(data, Sensor, SM) # creates columns with the SM separated by sensor

# Separate the substations
data.002=data.frame('Date'=data$Date, 's1'=data$`1`, 's2'=data$`2`, 's3'=data$`3`, 's4'=data$`4`) # first substation
data.102=data.frame('Date'=data$Date, 's1'=data$`5`, 's2'=data$`6`, 's3'=data$`7`, 's4'=data$`8`) # second substation

# ETr (mm)
ETr=read_xlsx('ETr.xlsx')
d1=data.002$Date[1]-ETr$date_time[1] # initial offset in dates
d1=length(numeric(d1))
d2=length(data.002$Date)
data.002$ETr=ETr$etr[(d1+1):(d1+d2)]
data.102$ETr=ETr$etr[(d1+1):(d1+d2)]

# Root depth (mm)
zr=read_xlsx('CornRD.2019.xlsx')
data.002$zr=zr$Zr[(d1+1):(d1+d2)]
data.102$zr=zr$Zr[(d1+1):(d1+d2)]

# Irrigation dates
Irr=read_xlsx('Irrigation.Corn.xlsx')
data.002$Irrigation=Irr$Corn[(d1+1):(d1+d2)]
data.102$Irrigation=Irr$Corn[(d1+1):(d1+d2)]

# Create a folder for each substation
dir.create('Sensor.002')
dir.create('Sensor.102')

# Create a csv for each substation
write_xlsx(data.002, 'Sensor.002/data.002.xlsx')
write_xlsx(data.102, 'Sensor.102/data.102.xlsx')
