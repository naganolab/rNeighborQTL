#' Calculating a set of self QTL effects from conditional genotype probabilities
#'
#' A function to reshape \code{qtl2}'s object of conditional genotype probabilities, and to calculate self QTL effects for all individuals with given deviation coefficients and conditional genotype probabilities.
#' @param genoprobs Conditional genotype probabilities as obtained from \code{qtl2::calc_genoprob()}.
#' @param gmap Genetic map including observed and pseudomarkers, as obtained from \code{qtl2::insert_pseudomarkers()}.
#' @param a1 A numeric scalar indicating additive deviation.
#' @param d1 A numeric scalar indicating dominance deviation.
#' @param contrasts A vector composed of three TRUE/FALSE values. Depending on crossing design, it represents the presence/absence of specific genotypes as c(TRUE/FALSE, TRUE/FALSE, TRUE/FALSE) = AA, AB, BB.
#' @return A numeric matrix containing individuals x marker elements for self QTL effects.
#' @author Yasuhiro Sato (\email{sato.yasuhiro.36c@kyoto-u.jp})
genoprobs2selfprobs = function(genoprobs, gmap, a1, d1, contrasts=c(TRUE,TRUE,TRUE)) {
  p = dim(genoprobs[[1]])[1]
  geno = decompose_genoprobs(genoprobs=genoprobs, contrasts=contrasts)

  selfList = c()
  for(i in 1:p) selfList = rbind(selfList, selfprob(i, a1=a1, d1=d1, AA=geno$AA, AB=geno$AB, BB=geno$BB))

  marker_info = get_markers(gmap)
  colnames(selfList) = rownames(marker_info)
  rownames(selfList) = rownames(genoprobs[[1]])
  return(selfList)
}
