## code to prepare `DATASET` dataset goes here
library(minfi)
setwd("/Users/ccgmlihua/Documents/CUHK/Research projects/George Ohia HLHS mouse model/data/Abha/db/")


anno=readRDS("ann285k_annotated.rds")
dim(anno)

## Annotation package
#anno <- maniTmp$manifest
#head(anno)
#anno$IlmnID <- NULL
#anno=anno1
nam <- names(anno)
names(nam) <- nam
#nam[c("AddressA_ID", "AddressB_ID", "AlleleA_ProbeSeq", "AlleleB_ProbeSeq",
#            "Infinium_Design_Type", "Next_Base", "Color_Channel")] <-  c("AddressA", "AddressB",
#                                                                         "ProbeSeqA", "ProbeSeqB",
#                                                                         "Type", "NextBase", "Color")
names(nam) <- NULL
names(anno) <- nam
rownames(anno) <- anno$Name
anno <- anno[getManifestInfo(IlluminaMouse1Methylationmanifest, type = "locusNames"),]


Locations <- anno[, c("chr", "pos","strand.x")]
names(Locations) <- c("chr", "pos","strand")
Locations$pos <- as.integer(Locations$pos)
#Locations$chr <- paste("chr", Locations$chr, sep = "")
#Locations$strand <- ifelse(anno$Strand == "F", "+", "-")
table(Locations$chr, exclude = NULL)
#rownames(Locations) <- anno$Name
Locations <- as(Locations, "DataFrame")
head(Locations)

R
Manifest <- anno[, c("Name", "AddressA", "AddressB",
                     "ProbeSeqA", "ProbeSeqB", "Type", "NextBase", "Color")]
Manifest <- as(Manifest, "DataFrame")

library(data.table)
# cpg island: Islands_Name Relation_to_Island
cpg=anno[,c("CpG_Island","N_Shore",  "N_Shelf", "S_Shore",  "S_Shelf")]
#names(cpg)=c("Islands_Name","Relation_to_Island")
#names(cpg)[6]="Relation_to_Island"
cpg$Relation_to_Island="OpenSea"
#cpg$Relation_to_Island="OpenSea"
head(cpg)
cpg$Relation_to_Island[cpg$N_Shore  %like% ":"]="N_Shore"
cpg$Relation_to_Island[cpg$N_Shelf  %like% ":"]="N_Shelf"
cpg$Relation_to_Island[cpg$S_Shore  %like% ":"]="S_Shore"
cpg$Relation_to_Island[cpg$S_Shelf  %like% ":"]="S_Shelf"
cpg$Relation_to_Island[cpg$CpG_Island  %like% ":"]="Island"
table(cpg$Relation_to_Island)
#Island N_Shelf N_Shore OpenSea S_Shelf S_Shore 
#  30222    6619   14490  205465    8101   16724 
cpg.1=cpg[,c(1,6)]
head(cpg.1)
Islands.UCSC=cpg.1
table(Islands.UCSC$Relation_to_Island, exclude = NULL)

usedColumns <- c(names(Manifest),  
                 c("chr", "pos", "strand.x"),
                 c("UCSC_CpG_Islands_Name", "N_Shore",  "N_Shelf", "S_Shore",  "S_Shelf"))
Other <- anno[, setdiff(names(anno), usedColumns)]
nam <- names(Other)
nam <- sub("_NAME", "_Name", nam)
#nam[nam == "X450k_Enhancer"] <- "Methyl450_Enhancer"
nam
Other <- as(Other, "DataFrame")
head(Other)

annoNames <- c("Locations", "Manifest", "Islands.UCSC", "Other")
for(nam in annoNames) {
  cat(nam, "\n")
  #save(list = nam, file = file.path("./", paste(nam, "rda", sep = ".")), compress = "xz")
}
annoStr <- c(array = "IlluminaMouse1Methylation",
             annotation = "ilm10a1",
             genomeBuild = "mm10")
defaults <- c("Locations", "Manifest", "Islands.UCSC", "Other")
pkgName <- sprintf("%sanno.%s.%s", annoStr["array"], annoStr["annotation"],
                   annoStr["genomeBuild"])

annoObj <- IlluminaMethylationAnnotation(objectNames = annoNames, annotation = annoStr,
                                                                        defaults = defaults, packageName = pkgName)
IlluminaMouse1Methylationanno.ilm10a1.mm10 = pkgName
assign(IlluminaMouse1Methylationanno.ilm10a1.mm10, annoObj)
#save(list = pkgName,
#     file = file.path("./", paste(pkgName, "rda", sep = ".")), 
#     compress = "xz")

usethis::use_data(IlluminaMouse1Methylationanno.ilm10a1.mm10, overwrite = TRUE)
