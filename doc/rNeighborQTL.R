## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,  fig.width = 4, fig.height = 4,
  comment = "#>"
)

## ----input--------------------------------------------------------------------
colkas <- qtl::read.cross(format="csvs",dir="../inst",
                    genfile="ColKas_geno.csv",
                    phefile = "ColKas_pheno.csv",
                    na.strings = c("_"), estimate.map=TRUE, crosstype = "riself")
colkas <- qtl2::convert2cross2(colkas)

gmap_colkas <- qtl2::insert_pseudomarkers(colkas$gmap, step=2)
colkas_genoprob <- qtl2::calc_genoprob(colkas,gmap_colkas)

## ----pve----------------------------------------------------------------------
library(rNeighborQTL)
x <- colkas$pheno[,2]
y <- colkas$pheno[,3]
smap_colkas <- data.frame(x,y)

s_seq <- quantile(dist(smap_colkas),c(0.1*(1:10)))
colkas_pve <- calc_pve(genoprobs=colkas_genoprob,
                       pheno=log(colkas$pheno[,4]+1),
                       gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                       addcovar=colkas$pheno[,6:8], 
                       smap=smap_colkas, s_seq=s_seq
                       )

## ----eff, fig.width=4, fig.height=8-------------------------------------------
colkas_eff <- eff_neighbor(genoprobs=colkas_genoprob,
                           pheno=log(colkas$pheno[,4]+1),
                           gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                           smap=smap_colkas, scale=7,
                           addcovar=colkas$pheno[,6:8]
                           )

## ----LOD----------------------------------------------------------------------
colkas_scan <- scan_neighbor(genoprobs=colkas_genoprob, 
                             pheno=log(colkas$pheno[,4]+1),
                             gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                             smap=smap_colkas, scale=7, 
                             addcovar=colkas$pheno[,6:8]
                             )
plot_nei(colkas_scan)

## ----perm---------------------------------------------------------------------
colkas_perm <- perm_neighbor(genoprobs=colkas_genoprob, pheno=log(colkas$pheno[,4]+1),
                            gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                            smap=smap_colkas, scale=7,
                            addcovar=colkas$pheno[,6:8],
                            times=99, p_val=c(0.1,0.05,0.01))
print(colkas_perm)

## ----self---------------------------------------------------------------------
plot_nei(colkas_scan, type="self")
colkas_scan1 <- qtl2::scan1(colkas_genoprob,pheno=log(colkas$pheno[,4]+1),addcovar=colkas$pheno[,6:8])
plot(colkas_scan1, map=gmap_colkas)

## ----CIM----------------------------------------------------------------------
colkas_cim <- scan_neighbor(genoprobs=colkas_genoprob, pheno=log(colkas$pheno[,4]+1),
                            gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                            smap=smap_colkas, scale=7,
                            addcovar=colkas$pheno[,6:8],
                            addQTL="nga8"
                            )
plot_nei(colkas_cim)

## ----int----------------------------------------------------------------------
colkas_int <- int_neighbor(genoprobs=colkas_genoprob, 
                           pheno=log(colkas$pheno[,4]+1), 
                           gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                           smap=smap_colkas, scale=7, 
                           addcovar=colkas$pheno[,6:8], 
                           addQTL="nga8", intQTL="nga8"
                           )
plot_nei(colkas_int, type="int")

## ----bin----------------------------------------------------------------------
s_seq <- quantile(dist(smap_colkas),c(0.1*(1:10)))
colkas_pveBin <- calc_pve(genoprobs=colkas_genoprob, pheno=colkas$pheno[,6],
                       gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                       smap=smap_colkas, s_seq=s_seq,
                       response="binary", addcovar=colkas$pheno[,7:8], fig=TRUE
                       )

colkas_scanBin <- scan_neighbor(genoprobs=colkas_genoprob, pheno=colkas$pheno[,6],
                                gmap=gmap_colkas, contrasts=c(TRUE,FALSE,TRUE),
                                smap_colkas, scale=2.24,
                                addcovar=colkas$pheno[,7:8], response="binary"
                                )

plot_nei(colkas_scanBin)

## ----fake---------------------------------------------------------------------
#F2 lines
set.seed(1234)
data("fake.f2",package="qtl")
fake_f2 <- qtl2::convert2cross2(fake.f2)
fake_f2 <- subset(fake_f2,chr=c(1:19))
smap_f2 <- cbind(runif(qtl2::n_ind(fake_f2),1,100),runif(qtl2::n_ind(fake_f2),1,100))
gmap_f2 <- qtl2::insert_pseudomarkers(fake_f2$gmap, step=2)
genoprobs_f2 <- qtl2::calc_genoprob(fake_f2,gmap_f2)
s_seq <- quantile(dist(smap_f2),c(0.1*(1:10)))

nei_eff <- sim_nei_qtl(genoprobs_f2, gmap_f2, a2=0.5, d2=0.5, 
                       contrasts=c(TRUE,TRUE,TRUE), smap=smap_f2, 
                       scale=s_seq[1], n_QTL=1)

pve_f2 <- calc_pve(genoprobs=genoprobs_f2,
                       pheno=nei_eff$nei_y,
                       gmap=gmap_f2, contrasts=c(TRUE,TRUE,TRUE),
                       smap=smap_f2, s_seq=s_seq[1:5],
                       addcovar=as.matrix(fake_f2$covar), fig=FALSE)
    
deltaPVE <- pve_f2[,2] - c(0,pve_f2[1:4,2])
argmax_s <- s_seq[1:5][deltaPVE==max(deltaPVE)]
    
scan_f2 <- scan_neighbor(genoprobs=genoprobs_f2,
                         pheno=nei_eff$nei_y,
                         gmap=gmap_f2, contrasts=c(TRUE,TRUE,TRUE),
                         smap=smap_f2, scale=argmax_s,
                         addcovar=as.matrix(fake_f2$covar)
                         )
    
plot_nei(scan_f2)

## ----bc-----------------------------------------------------------------------
#backcross lines
set.seed(1234)
data("fake.bc",package="qtl")
fake_bc <- qtl2::convert2cross2(fake.bc)
fake_bc <- subset(fake_bc,chr=c(1:19))
smap_bc <- cbind(runif(qtl2::n_ind(fake_bc),1,100),runif(qtl2::n_ind(fake_bc),1,100))
s_seq <- quantile(dist(smap_bc),c(0.1*(1:10)))
gmap_bc <- qtl2::insert_pseudomarkers(fake_bc$gmap, step=2)
genoprobs_bc <- qtl2::calc_genoprob(fake_bc,gmap_bc)

nei_eff <- sim_nei_qtl(genoprobs_bc, gmap_bc, a2=0.3, d2=-0.3, 
                       contrasts=c(TRUE,TRUE,FALSE), smap=smap_bc, 
                       scale=s_seq[1], n_QTL=1)

pve_bc <- calc_pve(genoprobs=genoprobs_bc,
                       pheno=nei_eff$nei_y,
                       gmap=gmap_bc, contrasts=c(TRUE,TRUE,FALSE),
                       smap=smap_bc, s_seq=s_seq[1:5],
                       addcovar=as.matrix(fake_bc$covar), fig=FALSE)
    
deltaPVE <- pve_bc[,2] - c(0,pve_bc[1:4,2])
argmax_s <- s_seq[1:5][deltaPVE==max(deltaPVE)]
    
scan_bc <- scan_neighbor(genoprobs=genoprobs_bc,
                         pheno=nei_eff$nei_y,
                         gmap=gmap_bc, contrasts=c(TRUE,TRUE,FALSE),
                         smap=smap_bc, scale=argmax_s,
                         addcovar=as.matrix(fake_bc$covar)
                         )

plot_nei(scan_bc)

