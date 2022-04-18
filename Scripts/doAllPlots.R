list <- c("deu", "eng", "fra", "hun", "nor", "por", "rom", "slv", "srp")
listnoisy <- c("hun", "por", "rom", "slv", "srp")
listembeddings <- c("deu", "hun", "por", "srp")

for (i in listnoisy) {
 daf <- i 
 filename <- paste0("/home/lou/Public/ELTeC-data/",i,"/verbCount_noisy.csv")
 assign(daf, read.table(filename,header=TRUE))
 }

for (i in list) {
 daf <- paste0(i,"unamb") 
 filename <- paste0("/home/lou/Public/ELTeC-data/",i,"/verbCount_pure.csv")
 assign(daf, read.table(filename,header=TRUE))
 }

for (i in listembeddings) {
 daf <- paste0(i,"embed") 
 filename <- paste0("/home/lou/Public/ELTeC-data/",i,"/verbCount_w2v.csv")
 assign(daf, read.table(filename,header=TRUE))
 }


compute_decade<-function(x) {
trunc((x-1840)/10)+1}
fiveyears<-function(x) {
trunc((x-1840)/5)+1}
twentyyears<-function(x) {
trunc((x-1840)/20)+1}


por<-cbind(por,decade=compute_decade(por$year),five=fiveyears(por$year),twenty=twentyyears(por$year))
porunamb<-cbind(porunamb,decade=compute_decade(porunamb$year),five=fiveyears(porunamb$year),twenty=twentyyears(porunamb$year))
porembed<-cbind(porembed,decade=compute_decade(porembed$year),five=fiveyears(porembed$year),twenty=twentyyears(porembed$year))

srp<-cbind(srp,decade=compute_decade(srp$year),five=fiveyears(srp$year),twenty=twentyyears(srp$year))
srpunamb<-cbind(srpunamb,decade=compute_decade(srpunamb$year),five=fiveyears(srpunamb$year),twenty=twentyyears(srpunamb$year))
srpembed<-cbind(srpembed,decade=compute_decade(srpembed$year),five=fiveyears(srpembed$year),twenty=twentyyears(srpembed$year))

hun<-cbind(hun,decade=compute_decade(hun$year),five=fiveyears(hun$year),twenty=twentyyears(hun$year))
hununamb<-cbind(hununamb,decade=compute_decade(hununamb$year),five=fiveyears(hununamb$year),twenty=twentyyears(hununamb$year))
hunembed<-cbind(hunembed,decade=compute_decade(hunembed$year),five=fiveyears(hunembed$year),twenty=twentyyears(hunembed$year))

slv<-cbind(slv,decade=compute_decade(slv$year),five=fiveyears(slv$year),twenty=twentyyears(slv$year))
slvunamb<-cbind(slvunamb,decade=compute_decade(slvunamb$year),five=fiveyears(slvunamb$year),twenty=twentyyears(slvunamb$year))

rom<-cbind(rom,decade=compute_decade(rom$year),five=fiveyears(rom$year),twenty=twentyyears(rom$year))
romunamb<-cbind(romunamb,decade=compute_decade(romunamb$year),five=fiveyears(romunamb$year),twenty=twentyyears(romunamb$year))

engunamb<-cbind(engunamb,decade=compute_decade(engunamb$year),five=fiveyears(engunamb$year),twenty=twentyyears(engunamb$year))
fraunamb<-cbind(fraunamb,decade=compute_decade(fraunamb$year),five=fiveyears(fraunamb$year),twenty=twentyyears(fraunamb$year))
norunamb<-cbind(norunamb,decade=compute_decade(norunamb$year),five=fiveyears(norunamb$year),twenty=twentyyears(norunamb$year))


attach(por)
png("/home/lou/Public/ELTeC-data/por/10verbsgen.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Portuguese per five years")
dev.off()
detach(por)

attach(porunamb)
png("/home/lou/Public/ELTeC-data/por/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Portuguese per five years")
dev.off()
detach(porunamb)

attach(porembed)
png("/home/lou/Public/ELTeC-data/por/verbsembed.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in Portuguese per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in Portuguese per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in Portuguese per five years")
dev.off()
detach(porembed)

attach(srp)
png("/home/lou/Public/ELTeC-data/srp/10verbsgen.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Serbian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Serbian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Serbian per five years")
dev.off()
detach(srp)

attach(srpunamb)
png("/home/lou/Public/ELTeC-data/srp/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Serbian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Serbian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Serbian per five years")
dev.off()
detach(srpunamb)

attach(srpembed)
png("/home/lou/Public/ELTeC-data/srp/verbsembed.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in Serbian per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in Serbian per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in Serbian per five years")
dev.off()
detach(srpembed)

attach(slv)
png("/home/lou/Public/ELTeC-data/slv/10verbsgen.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Slovenian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Slovenian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Slovenian per five years")
dev.off()
detach(slv)

attach(slvunamb)
png("/home/lou/Public/ELTeC-data/slv/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Slovenian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Slovenian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Slovenian per five years")
dev.off()
detach(slvunamb)

attach(hun)
png("/home/lou/Public/ELTeC-data/hun/10verbsgen.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Hungarian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Hungarian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Hungarian per five years")
dev.off()
detach(hun)

attach(hununamb)
png("/home/lou/Public/ELTeC-data/hun/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Hungarian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Hungarian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Hungarian per five years")
dev.off()
detach(hununamb)

attach(hunembed)
png("/home/lou/Public/ELTeC-data/hun/verbsembed.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="Inner life verbs in Hungarian per decade")
boxplot(innerVerbs/verbs~twenty, main="Inner life verbs in Hungarian per twenty years")
boxplot(innerVerbs/verbs~five, main="Inner life verbs in Hungarian per five years")
dev.off()
detach(hunembed)

attach(rom)
png("/home/lou/Public/ELTeC-data/rom/10verbsgen.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Generally) inner life verbs in Romanian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Generally) inner life verbs in Romanian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Generally) inner life verbs in Romanian per five years")
dev.off()
detach(rom)

attach(romunamb)
png("/home/lou/Public/ELTeC-data/rom/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Romanian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Romanian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Romanian per five years")
dev.off()
detach(romunamb)

attach(engunamb)
png("/home/lou/Public/ELTeC-data/eng/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in English per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in English per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in English per five years")
dev.off()
detach(engunamb)

attach(fraunamb)
png("/home/lou/Public/ELTeC-data/fra/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in French per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in French per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in French per five years")
dev.off()
detach(fraunamb)


attach(norunamb)
png("/home/lou/Public/ELTeC-data/nor/10verbsunamb.png",height=10,width=30,units="cm", res=800)
par(mfrow=c(1,3))
boxplot(innerVerbs/verbs~decade, main="(Unambiguously) inner life verbs in Norwegian per decade")
boxplot(innerVerbs/verbs~twenty, main="(Unambiguously) inner life verbs in Norwegian per twenty years")
boxplot(innerVerbs/verbs~five, main="(Unambiguously) inner life verbs in Norwegian per five years")
dev.off()
detach(norunamb)




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

all <-rbind(porshort,engshort)
all<-rbind(frashort,all)
all<-rbind(hunshort,all)
all<-rbind(slvshort,all)
all<-rbind(srpshort,all)
all<-rbind(norshort,all)
all<-rbind(romshort,all)


all$lang<-as.factor(sub( "^([A-Z][A-Z][A-Z]*).*", "\\1", all$textId, perl=TRUE))

# for Romanian... but then I removed from the verbCounter files, so no need
#allclean<-subset(all,all$year!=9999)

attach(all)
png("All.png",height=10,width=30,units="cm", res=800)
boxplot(innerVerbs/verbs~decade, main="Rel. frequency of inner life verbs in all languages per decade")
dev.off()
png("perLanguage.png",height=10,width=30,units="cm", res=800)
boxplot(innerVerbs/verbs~decade+lang, main="Relative frequency of inner life verbs per decade", las=2)
dev.off()

# figure using the three word embeddings
porembshort<-subset(porembed,TRUE,c(1:4,68:70))
hunembshort<-subset(hunembed,TRUE,c(1:4,46:48))
srpembshort<-subset(srpembed,TRUE,c(1:4,77:79))


allemb <-rbind(porembshort,hunembshort)
allemb<-rbind(srpembshort,allemb)

allemb$lang<-as.factor(sub( "^([A-Z][A-Z][A-Z]*).*", "\\1", allemb$textId, perl=TRUE))

attach(allemb)
png("Allemb.png",height=10,width=30,units="cm", res=800)
boxplot(innerVerbs/verbs~decade, main="Rel. frequency of inner life verbs in all three languages per decade, using embeddings")
dev.off()
png("perLanguageemb.png",height=10,width=30,units="cm", res=800)
boxplot(innerVerbs/verbs~decade+lang, main="Relative frequency of inner life verbs per decade, using embeddings", las=2)
dev.off()
detach(allemb)

# Figures without boxplots
por<-por[order(por$year),]
por$rel<-por$innerVerbs/por$verbs
lm(rel~year,data=por)
plot(por$year,por$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 generally inner life verbs in Portuguese")
lines(lowess(por$year,por$rel))

porunamb<-porunamb[order(porunamb$year),]
porunamb$rel<-porunamb$innerVerbs/porunamb$verbs
lm(rel~year,data=porunamb)
plot(porunamb$year,porunamb$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 unambiguously inner life verbs in Portuguese")
lines(lowess(porunamb$year,porunamb$rel))

porembed<-porembed[order(porembed$year),]
porembed$rel<-porembed$innerVerbs/porembed$verbs
lm(rel~year,data=porembed)
plot(porembed$year,porembed$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 inner life verbs in Portuguese")
lines(lowess(porembed$year,porembed$rel))
points(porunamb$year,porunamb$rel,col="green")

png("PortugueseLinear.png",height=10,width=30,units="cm", res=800)
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
png("SerbianLinear.png",height=10,width=30,units="cm", res=800)
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
png("SlovenianLinear.png",height=10,width=30,units="cm", res=800)
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
png("HungarianLinear.png",height=10,width=30,units="cm", res=800)
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
png("RomanianLinear.png",height=10,width=30,units="cm", res=800)
plot(rom$year,rom$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="Manual choice of 10 inner life verbs in Romanian", col="red")
lines(lowess(rom$year,rom$rel),col="red")
points(romunamb$year,romunamb$rel,col="green")
lines(lowess(romunamb$year,romunamb$rel),col="green")
legend("topleft",col=c("red","green"), legend=c("10 general","10 unambiguous"),pch=1)
dev.off()

# All (unambiguous) languages
engunamb<-engunamb[order(engunamb$year),]
engunamb$rel<-engunamb$innerVerbs/engunamb$verbs
fraunamb<-fraunamb[order(fraunamb$year),]
fraunamb$rel<-fraunamb$innerVerbs/fraunamb$verbs
norunamb<-norunamb[order(norunamb$year),]
norunamb$rel<-norunamb$innerVerbs/norunamb$verbs

png("alllang.png",height=10,width=30,units="cm", res=800)

plot(fraunamb$year,fraunamb$rel,xlab="publication year",ylab="Relative number of inner life verbs", main="10 Manual unambiguous inner life verbs",ylim=c(0,0.13))
lines(lowess(fraunamb$year,fraunamb$rel))
lines(lowess(porunamb$year,porunamb$rel),col="green")
lines(lowess(hununamb$year,hununamb$rel),col="blue")
lines(lowess(engunamb$year,engunamb$rel),col="red")
lines(lowess(srpunamb$year,srpunamb$rel),col="brown")
lines(lowess(slvunamb$year,slvunamb$rel),col="gray")
lines(lowess(norunamb$year,norunamb$rel),col="violet")
lines(lowess(romunamb$year,romunamb$rel),col="orange")
legend("topleft",col=c("black","green","blue","red","brown","gray","violet","orange"), legend=c("fra","por","hun","eng","srp","slv","nor","rom"),pch=1)
dev.off()
