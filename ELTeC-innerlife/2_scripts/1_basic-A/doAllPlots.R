list <- c("deu", "eng", "fra", "hun", "nor", "por", "rom", "slv", "srp")
listnoisy <- c("deu", "hun", "por", "rom", "slv", "srp")
listembeddings <- c("deu", "hun", "por", "srp")

rootdir<-"/home/lou/Public/ELTeC-data/"

for (i in listnoisy) {
 daf <- i 
 filename <- paste0(rootdir,i,"/verbCount_noisy.csv")
 assign(daf, read.table(filename,header=TRUE))
 }

for (i in list) {
 daf <- paste0(i,"unamb") 
 filename <- paste0(rootdir,i,"/verbCount_pure.csv")
 assign(daf, read.table(filename,header=TRUE))
 }

for (i in listembeddings) {
 daf <- paste0(i,"embed") 
 filename <- paste0(rootdir,i,"/verbCount_w2v.csv")
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

srp<-cbind(srp,decade=compute_decade(srp$year),five=fiveyears(srp$year),twenty=twentyyears(srp$year))
srpunamb<-cbind(srpunamb,decade=compute_decade(srpunamb$year),five=fiveyears(srpunamb$year),twenty=twentyyears(srpunamb$year))
srpembed<-cbind(srpembed,decade=compute_decade(srpembed$year),five=fiveyears(srpembed$year),twenty=twentyyears(srpembed$year))

hun<-cbind(hun,decade=compute_decade(hun$year),five=fiveyears(hun$year),twenty=twentyyears(hun$year))
hununamb<-cbind(hununamb,decade=compute_decade(hununamb$year),five=fiveyears(hununamb$year),twenty=twentyyears(hununamb$year))
hunembed<-cbind(hunembed,decade=compute_decade(hunembed$year),five=fiveyears(hunembed$year),twenty=twentyyears(hunembed$year))

deu<-deu[deu$year!="1840",]
deu<- cbind(deu,decade=compute_decade(deu$year),five=fiveyears(deu$year),twenty=twentyyears(deu$year))
deuunamb<-deuunamb[deuunamb$year!="1840",]
deuunamb<-cbind(deuunamb,decade=compute_decade(deuunamb$year),five=fiveyears(deuunamb$year),twenty=twentyyears(deuunamb$year))
deuembed<-deuembed[deuembed$year!="1840",]
deuembed<-cbind(deuembed,decade=compute_decade(deuembed$year),five=fiveyears(deuembed$year),twenty=twentyyears(deuembed$year))

slv<-cbind(slv,decade=compute_decade(slv$year),five=fiveyears(slv$year),twenty=twentyyears(slv$year))
slvunamb<-cbind(slvunamb,decade=compute_decade(slvunamb$year),five=fiveyears(slvunamb$year),twenty=twentyyears(slvunamb$year))

rom<-cbind(rom,decade=compute_decade(rom$year),five=fiveyears(rom$year),twenty=twentyyears(rom$year))
romunamb<-cbind(romunamb,decade=compute_decade(romunamb$year),five=fiveyears(romunamb$year),twenty=twentyyears(romunamb$year))

engunamb<-engunamb[engunamb$year!="1840",]
engunamb<-cbind(engunamb,decade=compute_decade(engunamb$year),five=fiveyears(engunamb$year),twenty=twentyyears(engunamb$year))
fraunamb<-

fraunamb<-fraunamb[fraunamb$year!="1840",]
fraunamb<-
cbind(fraunamb,decade=compute_decade(fraunamb$year),five=fiveyears(fraunamb$year),twenty=twentyyears(fraunamb$year))

norunamb<-norunamb[norunamb$year!="1840",]
norunamb<-cbind(norunamb,decade=compute_decade(norunamb$year),five=fiveyears(norunamb$year),twenty=twentyyears(norunamb$year))


attach(por)
png(paste0(rootdir,"Outputs/","por10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Portuguese per five years")
dev.off()
detach(por)

attach(porunamb)
png(paste0(rootdir,"Outputs/","por10verbsunamb.png"),height=10,width=30,units="cm",res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Portuguese per five years")
dev.off()
detach(porunamb)

attach(porembed)
png(paste0(rootdir,"Outputs/","porverbsembed.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in Portuguese per five years")
dev.off()
detach(porembed)

attach(srp)
png(paste0(rootdir,"Outputs/","srp10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Serbian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Serbian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Serbian per five years")
dev.off()
detach(srp)

attach(srpunamb)
png(paste0(rootdir,"Outputs/","srp10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Serbian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Serbian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Serbian per five years")
dev.off()
detach(srpunamb)

attach(srpembed)
png(paste0(rootdir,"Outputs/","srpverbsembed.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in Serbian per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in Serbian per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in Serbian per five years")
dev.off()
detach(srpembed)

attach(slv)
png(paste0(rootdir,"Outputs/","slv10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Slovenian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Slovenian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Slovenian per five years")
dev.off()
detach(slv)

attach(slvunamb)
png(paste0(rootdir,"Outputs/","slv10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Slovenian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Slovenian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Slovenian per five years")
dev.off()
detach(slvunamb)

attach(hun)
png(paste0(rootdir,"Outputs/","hun10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Hungarian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Hungarian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Hungarian per five years")
dev.off()
detach(hun)

attach(hununamb)
png(paste0(rootdir,"Outputs/","hun10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Hungarian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Hungarian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Hungarian per five years")
dev.off()
detach(hununamb)

attach(hunembed)
png(paste0(rootdir,"Outputs/","hunverbsembed.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in Hungarian per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in Hungarian per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in Hungarian per five years")
dev.off()
detach(hunembed)

attach(rom)
png(paste0(rootdir,"Outputs/","rom10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Romanian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Romanian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Romanian per five years")
dev.off()
detach(rom)

attach(romunamb)
png(paste0(rootdir,"Outputs/","rom10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Romanian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Romanian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Romanian per five years")
dev.off()
detach(romunamb)

attach(engunamb)
png(paste0(rootdir,"Outputs/","eng10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in English per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in English per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in English per five years")
dev.off()
detach(engunamb)

attach(fraunamb)
png(paste0(rootdir,"Outputs/","fra10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in French per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in French per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in French per five years")
dev.off()
detach(fraunamb)


attach(norunamb)
png(paste0(rootdir,"Outputs/","nor10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Norwegian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Norwegian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Norwegian per five years")
dev.off()
detach(norunamb)

attach(deu)
png(paste0(rootdir,"Outputs/","deu10verbsgen.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in German per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in German per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in German per five years")
dev.off()
detach(deu)

attach(deuunamb)
png(paste0(rootdir,"Outputs/","deu10verbsunamb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in German per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in German per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in German per five years")
dev.off()
detach(deuunamb)

attach(deuembed)
png(paste0(rootdir,"Outputs/","deuverbsembed.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in German per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in German per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in German per five years")
dev.off()
detach(deuembed)



porshort<-subset(porunamb,TRUE,c(1:4,15:17))
engshort<-subset(engunamb,TRUE,c(1:4,15:17))
frashort<-subset(fraunamb,TRUE,c(1:4,15:17))
#hunshort<-subset(hununamb,TRUE,c(1:4,15:17))# 14:16
hunshort<-subset(hununamb,TRUE,c(1:4,14:16))
slvshort<-subset(slvunamb,TRUE,c(1:4,15:17))
#srpshort<-subset(srpunamb,TRUE,c(1:4,15:17)) #13:15
srpshort<-subset(srpunamb,TRUE,c(1:4,13:15))
norshort<-subset(norunamb,TRUE,c(1:4,15:17))
romshort<-subset(romunamb,TRUE,c(1:4,15:17))
deushort<-subset(deuunamb,TRUE,c(1:4,15:17))

all <-rbind(porshort,engshort)
all<-rbind(frashort,all)
all<-rbind(hunshort,all)
all<-rbind(slvshort,all)
all<-rbind(srpshort,all)
all<-rbind(norshort,all)
all<-rbind(romshort,all)
all<-rbind(deushort,all)


all$lang<-as.factor(sub( "^([A-Z][A-Z][A-Z]*).*", "\\1", all$textId, perl=TRUE))


attach(all)
png(paste0(rootdir,"Outputs/","All.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Rel. frequency per decade")
boxplot(innerVerbs/verbs~twenty, main="Rel. frequency per 20 years")
boxplot(innerVerbs/verbs~five, main="Rel. frequency per 5 years")
dev.off()
png(paste0(rootdir,"Outputs/","perLanguage.png"),height=10,width=30,units="cm", res=800)
boxplot(innerVerbs/verbs~decade+lang, main="Relative frequency of inner life verbs per decade, using non-ambiguous verbs", las=2)
dev.off()

# figure using the four word embeddings
porembshort<-subset(porembed,TRUE,c(1:4,68:70))
hunembshort<-subset(hunembed,TRUE,c(1:4,46:48))
srpembshort<-subset(srpembed,TRUE,c(1:4,77:79))
deuembshort<-subset(deuembed,TRUE,c(1:4,101:103))


allemb <-rbind(porembshort,hunembshort)
allemb<-rbind(srpembshort,allemb)
allemb<-rbind(deuembshort,allemb)

allemb$lang<-as.factor(sub( "^([A-Z][A-Z][A-Z]*).*", "\\1", allemb$textId, perl=TRUE))

attach(allemb)
png(paste0(rootdir,"Outputs/","Allemb.png"),height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Rel. frequency per decade, using embeddings")
boxplot(innerVerbs/verbs~twenty, main="Rel. frequency per 20 years, using embeddings")
boxplot(innerVerbs/verbs~five, main="Rel. frequency per 5 years, using embeddings")
dev.off()
png(paste0(rootdir,"Outputs/","perLanguageemb.png"),height=10,width=30,units="cm", res=800)
boxplot(innerVerbs/verbs~decade+lang, main="Relative frequency of inner life verbs per decade, using embeddings", las=2)
dev.off()
detach(allemb)

# Figures without boxplots
por<-por[order(por$year),]
por$rel<-por$innerVerbs/por$verbs
#lm(rel~year,data=por)
#plot(por$year,por$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 generally inner life verbs in Portuguese")
#lines(lowess(por$year,por$rel))

porunamb<-porunamb[order(porunamb$year),]
porunamb$rel<-porunamb$innerVerbs/porunamb$verbs
#lm(rel~year,data=porunamb)
#plot(porunamb$year,porunamb$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 unambiguously inner life verbs in Portuguese")
#lines(lowess(porunamb$year,porunamb$rel))

porembed<-porembed[order(porembed$year),]
porembed$rel<-porembed$innerVerbs/porembed$verbs
#lm(rel~year,data=porembed)
#plot(porembed$year,porembed$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 inner life verbs in Portuguese")
#lines(lowess(porembed$year,porembed$rel))
#points(porunamb$year,porunamb$rel,col="green")

png(paste0(rootdir,"Outputs/","porLinear.png"),height=10,width=30,units="cm", res=800)
plot(porembed$year,porembed$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Inner life verbs in Portuguese", ylim=c(0,0.13))
lines(lowess(porembed$year,porembed$rel))
points(porunamb$year,porunamb$rel,col="green")
lines(lowess(porunamb$year,porunamb$rel),col="green")
points(por$year,por$rel,col="red")
lines(lowess(por$year,por$rel),col="red")
legend("topleft",col=c("black","red","green"), legend=c("word embeddings","10 general","10 unambiguous"),pch=1)
dev.off()

srp<-srp[order(srp$year),]
srp$rel<-srp$innerVerbs/srp$verbs
srpunamb<-srpunamb[order(srpunamb$year),]
srpunamb$rel<-srpunamb$innerVerbs/srpunamb$verbs
srpembed<-srpembed[order(srpembed$year),]
srpembed$rel<-srpembed$innerVerbs/srpembed$verbs
png(paste0(rootdir,"Outputs/","srpLinear.png"),height=10,width=30,units="cm", res=800)
plot(srpembed$year,srpembed$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Inner life verbs in Serbian", ylim=c(0,0.13))
lines(lowess(srpembed$year,srpembed$rel))
points(srpunamb$year,srpunamb$rel,col="green")
lines(lowess(srpunamb$year,srpunamb$rel),col="green")
points(srp$year,srp$rel,col="red")
lines(lowess(srp$year,srp$rel),col="red")
legend("topleft",col=c("black","red","green"), legend=c("word embeddings","10 general","10 unambiguous"),pch=1)
dev.off()

slv<-slv[order(slv$year),]
slv$rel<-slv$innerVerbs/slv$verbs
slvunamb<-slvunamb[order(slvunamb$year),]
slvunamb$rel<-slvunamb$innerVerbs/slvunamb$verbs
png(paste0(rootdir,"Outputs/","slvLinear.png"),height=10,width=30,units="cm", res=800)
plot(slv$year,slv$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 inner life verbs in Slovenian", col="red")
lines(lowess(slv$year,slv$rel),col="red")
points(slvunamb$year,slvunamb$rel,col="green")
lines(lowess(slvunamb$year,slvunamb$rel),col="green")
legend("topleft",col=c("red","green"), legend=c("10 general","10 unambiguous"),pch=1)
dev.off()

hun<-hun[order(hun$year),]
hun$rel<-hun$innerVerbs/hun$verbs
hununamb<-hununamb[order(hununamb$year),]
hununamb$rel<-hununamb$innerVerbs/hununamb$verbs
png(paste0(rootdir,"Outputs/","hunLinear.png"),height=10,width=30,units="cm", res=800)
plot(hun$year,hun$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 inner life verbs in Hungarian", col="red")
lines(lowess(hun$year,hun$rel),col="red")
points(hununamb$year,hununamb$rel,col="green")
lines(lowess(hununamb$year,hununamb$rel),col="green")
legend("topleft",col=c("red","green"), legend=c("10 general","10 unambiguous"),pch=1)
dev.off()

rom<-rom[order(rom$year),]
rom$rel<-rom$innerVerbs/rom$verbs
romunamb<-romunamb[order(romunamb$year),]
romunamb$rel<-romunamb$innerVerbs/romunamb$verbs
png(paste0(rootdir,"Outputs/","romLinear.png"),height=10,width=30,units="cm", res=800)
plot(rom$year,rom$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 inner life verbs in Romanian", col="red")
lines(lowess(rom$year,rom$rel),col="red")
points(romunamb$year,romunamb$rel,col="green")
lines(lowess(romunamb$year,romunamb$rel),col="green")
legend("topleft",col=c("red","green"), legend=c("10 general","10 unambiguous"),pch=1)
dev.off()

deu<-deu[order(deu$year),]
deu$rel<-deu$innerVerbs/deu$verbs
deuunamb<-deuunamb[order(deuunamb$year),]
deuunamb$rel<-deuunamb$innerVerbs/deuunamb$verbs
deuembed<-deuembed[order(deuembed$year),]
deuembed$rel<-deuembed$innerVerbs/deuembed$verbs
png(paste0(rootdir,"Outputs/","deuLinear.png"),height=10,width=30,units="cm", res=800)
plot(deuembed$year,deuembed$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Inner life verbs in German", ylim=c(0,0.17))
lines(lowess(deuembed$year,deuembed$rel))
points(deuunamb$year,deuunamb$rel,col="green")
lines(lowess(deuunamb$year,deuunamb$rel),col="green")
lines(lowess(deu$year,deu$rel),col="red")
points(deu$year,deu$rel,col="red")
legend("topleft",col=c("black","red","green"), legend=c("word embeddings","10 general","10 unambiguous"),pch=1)
dev.off()

# All (unambiguous) languages
engunamb<-engunamb[order(engunamb$year),]
engunamb$rel<-engunamb$innerVerbs/engunamb$verbs
fraunamb<-fraunamb[order(fraunamb$year),]
fraunamb$rel<-fraunamb$innerVerbs/fraunamb$verbs
norunamb<-norunamb[order(norunamb$year),]
norunamb$rel<-norunamb$innerVerbs/norunamb$verbs

png(paste0(rootdir,"Outputs/","allLinear.png"),height=10,width=30,units="cm", res=800)

plot(fraunamb$year,fraunamb$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Top 10 unambiguously inner life verbs",ylim=c(0,0.13))
lines(lowess(fraunamb$year,fraunamb$rel))
lines(lowess(porunamb$year,porunamb$rel),col="green")
lines(lowess(hununamb$year,hununamb$rel),col="blue")
lines(lowess(engunamb$year,engunamb$rel),col="red")
lines(lowess(srpunamb$year,srpunamb$rel),col="brown")
lines(lowess(slvunamb$year,slvunamb$rel),col="gray")
lines(lowess(norunamb$year,norunamb$rel),col="violet")
lines(lowess(romunamb$year,romunamb$rel),col="orange")
lines(lowess(deuunamb$year,deuunamb$rel),col="darkgreen")
legend("topleft",col=c("black","green","blue","red","brown","gray","violet","orange","darkgreen"), legend=c("fra","por","hun","eng","srp","slv","nor","rom","deu"),pch=1)
dev.off()
