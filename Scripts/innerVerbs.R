args = commandArgs(trailingOnly=TRUE)
if (length(args) ==0) {
  stop("And which repository are we dealing with?", call.=FALSE)
} else if (length(args)==2) {
  verbToPlot = args[2]
}
# read in the data

fileName=paste("../",args[1],"/verbCount_pure.csv", sep="")
message=paste("Computing boxplots for",fileName)
print(message)

dataset<-read.table(fileName,header=TRUE)

# creates some extra columns for timespans
compute_decade<-function(x) {
trunc((x-1839)/10)+1}
fiveyears<-function(x) {
trunc((x-1839)/5)+1}
twentyyears<-function(x) {
trunc((x-1839)/20)+1}
dataset$decade<-compute_decade(dataset$year)
dataset$five<-fiveyears(dataset$year)
dataset$twenty<-twentyyears(dataset$year)

# creates another column with all inner life verbs
dataset$inner<-dataset$innerVerbs

# now plot the variety of inner life per decade, 20year, 5 year

attach(dataset)
boxplot(inner/verbs~decade, main="Relative frequency of inner life verbs per decade")
boxplot(inner/verbs~twenty, main="Relative frequency of inner life verbs per twenty years")
boxplot(inner/verbs~five, main="Relative frequency of inner life verbs per five years")

# if you want to plot a particular verb
if (length(args)==2) {
whichVerb=args[2]
heading=paste("Relative frequency of '",whichVerb,"' by decade", sep="")
print(heading)
whichPlot=paste(whichVerb,"/verbs~decade", sep="")
boxplot(whichPlot, main=heading)
}
# if you want to print the picture to a pdf file, or png, just do
png("picture.png")
boxplot(inner/verbs~decade, main="Relative frequency of inner life verbs per decade")
dev.off()

