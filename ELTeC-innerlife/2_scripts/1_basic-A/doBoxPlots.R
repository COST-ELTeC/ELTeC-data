list <- c("deu", "fra", "hun", "nor", "por", "rom", "slv", "spa")

rootdir<-"/home/lou/Public/ELTeC-data/"

#functions to get counts by timeperiod
compute_decade<-function(x) {
  trunc((x-1841)/10)+1  }

fiveyears<-function(x) {
trunc((x-1841)/5)+1  }

twentyyears<-function(x) {
trunc((x-1841)/20)+1  }

#function to produce boxplots for nominated dataset 

do_plots <- function(x) {
# select output file
png(paste0(rootdir,x, "/boxPlots.png"),height=10,width=30,units="cm", res=800)

par(mfrow=c(1,3),cex.sub="1.5")
titre<-paste0('ELTeC-',x,' Inner-life verbs')
boxplot(innerVerbs/verbs~decade, main=titre, sub="per decade")
boxplot(innerVerbs/verbs~twenty, sub="per twenty years")
boxplot(innerVerbs/verbs~five, sub="per five years")
dev.off()
}

# create datasets for all available counts

for (i in list) {
 daf <- i 
 filename <- paste0(rootdir,i,"/innerVerbCounts.dat")
 assign(daf, read.table(filename,header=TRUE))
}

# produce boxplots
# dont know how to pass name of dataset as argument to function
# so we have to do this rather inelegantly

zzz<-cbind(fra,decade=compute_decade(fra$year),five=fiveyears(fra$year),twenty=twentyyears(fra$year))
attach(zzz)
 do_plots("fra")
detach(zzz)

zzz<-cbind(deu,decade=compute_decade(deu$year),five=fiveyears(deu$year),twenty=twentyyears(deu$year))
attach(zzz)
 do_plots("deu")
detach(zzz)

zzz<-cbind(hun,decade=compute_decade(hun$year),five=fiveyears(hun$year),twenty=twentyyears(hun$year))
attach(zzz)
 do_plots("hun")
detach(zzz)

zzz<-cbind(nor,decade=compute_decade(nor$year),five=fiveyears(nor$year),twenty=twentyyears(nor$year))
attach(zzz)
 do_plots("nor")
detach(zzz)

zzz<-cbind(por,decade=compute_decade(por$year),five=fiveyears(por$year),twenty=twentyyears(por$year))
attach(zzz)
 do_plots("por")
detach(zzz)

zzz<-cbind(rom,decade=compute_decade(rom$year),five=fiveyears(rom$year),twenty=twentyyears(rom$year))
attach(zzz)
 do_plots("rom")
detach(zzz)


zzz<-cbind(slv,decade=compute_decade(slv$year),five=fiveyears(slv$year),twenty=twentyyears(slv$year))
attach(zzz)
 do_plots("slv")
detach(zzz)

zzz<-cbind(spa,decade=compute_decade(spa$year),five=fiveyears(spa$year),twenty=twentyyears(spa$year))
attach(zzz)
 do_plots("spa")
detach(zzz)


