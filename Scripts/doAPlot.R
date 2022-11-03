listnoisy <- c("deu", "hun", "por", "rom", "slv", "spa")

rootdir<-"/home/lou/Public/ELTeC-data/"

for (i in listnoisy) {
 daf <- i 
 filename <- paste0(rootdir,i,"/innerVerbCounts.dat")
 assign(daf, read.table(filename,header=TRUE))
 }


compute_decade<-function(x) {
trunc((x-1841)/10)+1}
fiveyears<-function(x) {
trunc((x-1841)/5)+1}
twentyyears<-function(x) {
trunc((x-1841)/20)+1}


por<-cbind(por,decade=compute_decade(por$year),five=fiveyears(por$year),twenty=twentyyears(por$year))
porunamb<-cbind(porunamb,decade=compute_decade(porunamb$year),five=fiveyears(porunamb$year),twenty=twentyyears(porunamb$year))
porembed<-cbind(porembed,decade=compute_decade(porembed$year),five=fiveyears(porembed$year),twenty=twentyyears(porembed$year))

attach(por)
png(paste0(rootdir,"Outputs/","por10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Portuguese per five years")
dev.off()
detach(por)

attach(porembed)
png(paste0(rootdir,"Outputs/","porLinear.png"),height=10,width=30,units="cm", res=800)
plot(porembed$year,porembed$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Inner life verbs in Portuguese", ylim=c(0,0.13))
lines(lowess(porembed$year,porembed$rel))
points(porunamb$year,porunamb$rel,col="green")
lines(lowess(porunamb$year,porunamb$rel),col="green")
points(por$year,por$rel,col="red")
lines(lowess(por$year,por$rel),col="red")
legend("topleft",col=c("black","red","green"), legend=c("word embeddings","10 general","10 unambiguous"),pch=1)
dev.off()

detach(porembed)
